import FirebaseAuth
import GoogleSignIn
import UIKit

protocol AuthRepositoryProtocol {
    func signInWithGoogle(idToken: String, rememberMe: Bool) async throws -> String
    func login(email: String, password: String, rememberMe: Bool) async throws -> String
    func signup(email: String, password: String, rememberMe: Bool) async throws -> String
    func signOut() throws
    func resetPassword(email: String) async throws
    func storeUserCredentials(email: String, password: String)
    func getUserCredentials() -> (email: String, password: String)?
    func clearUserCredentials()
}

class AuthRepository: AuthRepositoryProtocol {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func signInWithGoogle(idToken: String, rememberMe: Bool) async throws -> String {
        do {
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: "")
            let authResult = try await Auth.auth().signIn(with: credential)
            let firebaseToken = try await authResult.user.getIDToken()

            return try await sendTokenToBackend(idToken: firebaseToken, rememberMe: rememberMe)
        } catch {
            throw AuthError.unknown(error)
        }
    }

    func login(email: String, password: String, rememberMe: Bool) async throws -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let firebaseToken = try await result.user.getIDToken()
            
            if rememberMe {
                storeUserCredentials(email: email, password: password)
            }

            return try await sendTokenToBackend(idToken: firebaseToken, rememberMe: rememberMe)
        } catch {
            throw mapAuthError(error)
        }
    }

    func signup(email: String, password: String, rememberMe: Bool) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let firebaseToken = try await result.user.getIDToken()

            if rememberMe {
                storeUserCredentials(email: email, password: password)
            }

            return try await sendTokenToBackend(idToken: firebaseToken, rememberMe: rememberMe)
        } catch {
            throw mapAuthError(error)
        }
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
            defaults.removeObject(forKey: "authToken")
            clearUserCredentials()
        } catch {
            throw AuthError.unknown(error)
        }
    }

    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw AuthError.unknown(error)
        }
    }

    func storeUserCredentials(email: String, password: String) {
        let expiryDate = Date().addingTimeInterval(30 * 24 * 60 * 60) // 30 days
        defaults.set(email, forKey: "rememberedEmail")
        defaults.set(password, forKey: "rememberedPassword")
        defaults.set(expiryDate, forKey: "credentialsExpiry")
    }

    func getUserCredentials() -> (email: String, password: String)? {
        guard let email = defaults.string(forKey: "rememberedEmail"),
              let password = defaults.string(forKey: "rememberedPassword"),
              let expiryDate = defaults.object(forKey: "credentialsExpiry") as? Date,
              expiryDate > Date() else {
            return nil
        }
        return (email, password)
    }

    func clearUserCredentials() {
        defaults.removeObject(forKey: "rememberedEmail")
        defaults.removeObject(forKey: "rememberedPassword")
        defaults.removeObject(forKey: "credentialsExpiry")
    }
    
    private func sendTokenToBackend(idToken: String, rememberMe: Bool) async throws -> String {
        let backendURL = URL(string: "https://api.planet-proxy.com/gateway/api/auth/login")!
        var request = URLRequest(url: backendURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(idToken, forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["deviceId": 123]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "AuthError", code: -4, userInfo: [NSLocalizedDescriptionKey: "No response from server"])
        }

        print("📡 Backend Response Status Code: \(httpResponse.statusCode)")

        if httpResponse.statusCode != 200 {
            throw NSError(domain: "AuthError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print("📜 Backend Response JSON: \(json ?? [:])")

            guard let dataDict = json?["data"] as? [String: Any],
                  let authToken = dataDict["token"] as? String else {
                throw NSError(domain: "AuthError", code: -5, userInfo: [NSLocalizedDescriptionKey: "Missing token in response"])
            }

            let expiryTime = rememberMe ? 30 * 24 * 60 * 60 : 30 * 24 * 60 * 60 // 1 minute when unchecked
            let expiryDate = Date().addingTimeInterval(Double(expiryTime))

            UserDefaults.standard.set(authToken, forKey: "authToken")
            UserDefaults.standard.set(expiryDate, forKey: "tokenExpiry")

            return authToken
        } catch {
            throw NSError(domain: "AuthError", code: -6, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
        }
    }
    

    private func mapAuthError(_ error: Error) -> AuthError {
    guard let error = error as NSError?, error.domain == AuthErrorDomain else {
        return .custom(NSLocalizedString("unexpected_error", comment: "Generic auth failure"))
    }

    switch error.code {
    case AuthErrorCode.userNotFound.rawValue:
        return .custom(NSLocalizedString("user_not_found", comment: "User does not exist"))
    case AuthErrorCode.wrongPassword.rawValue:
        return .custom(NSLocalizedString("wrong_password", comment: "Incorrect password"))
    case AuthErrorCode.emailAlreadyInUse.rawValue:
        return .custom(NSLocalizedString("email_already_registered", comment: "Email already registered"))
    case AuthErrorCode.networkError.rawValue:
        return .custom(NSLocalizedString("network_error", comment: "Network error"))
    case AuthErrorCode.userDisabled.rawValue:
        return .custom(NSLocalizedString("account_disabled", comment: "Account disabled"))
    default:
        return .custom(NSLocalizedString("unexpected_error", comment: "Authentication failed"))
    }
}

}
