import FirebaseAuth
import GoogleSignIn
import UIKit
import NetworkHelper

protocol AuthRepositoryProtocol {
    func signInWithGoogle(idToken: String, rememberMe: Bool) async throws
        -> String
    func login(email: String, password: String, rememberMe: Bool) async throws
        -> String
    func signup(email: String, password: String, rememberMe: Bool) async throws
        -> String
    func signOut() throws
    func resetPassword(email: String) async throws
    func storeUserCredentials(email: String, password: String)
    func getUserCredentials() -> (email: String, password: String)?
    func clearUserCredentials()
    func storeAuthToken(
        _ token: String, rememberMe: Bool, email: String?, password: String?)
    func loadAuthState() -> Bool
}

class AuthRepository: AuthRepositoryProtocol {
    private let defaults: UserDefaults

    private let vpnService = VpnRemoteService()

    init(
        defaults: UserDefaults = .standard
    ) {
        self.defaults = defaults
    }

    func signInWithGoogle(idToken: String, rememberMe: Bool) async throws
        -> String
    {
        do {
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString ?? ""
            )
            let authResult = try await Auth.auth().signIn(with: credential)
            let firebaseToken = try await authResult.user.getIDToken()

            return try await sendTokenToBackend(
                idToken: firebaseToken, rememberMe: rememberMe)
        } catch {
            throw AuthError.unknown(error)
        }
    }

    func login(email: String, password: String, rememberMe: Bool) async throws
        -> String
    {
        do {
            let result = try await Auth.auth().signIn(
                withEmail: email, password: password)
            let firebaseToken = try await result.user.getIDToken()

            if rememberMe {
                storeUserCredentials(email: email, password: password)
            }

            return try await sendTokenToBackend(
                idToken: firebaseToken, rememberMe: rememberMe)
        } catch {
            throw mapAuthError(error)
        }
    }

    func signup(email: String, password: String, rememberMe: Bool) async throws
        -> String
    {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: email, password: password)
            let firebaseToken = try await result.user.getIDToken()

            if rememberMe {
                storeUserCredentials(email: email, password: password)
            }

            return try await sendTokenToBackend(
                idToken: firebaseToken, rememberMe: rememberMe)
        } catch {
            throw mapAuthError(error)
        }
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "authToken")
            clearUserCredentials()
        } catch {
            throw AuthError.unknown(error)
        }
    }
    
    func loadAuthState() -> Bool {
            return defaults.string(forKey: "authToken") != nil
        }

    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw AuthError.unknown(error)
        }
    }

    func storeUserCredentials(email: String, password: String) {
        let expiryDate = Date().addingTimeInterval(30 * 24 * 60 * 60)  // 30 days
        defaults.set(email, forKey: "rememberedEmail")
        defaults.set(password, forKey: "rememberedPassword")
        defaults.set(expiryDate, forKey: "credentialsExpiry")
    }

    func storeAuthToken(_ token: String, rememberMe: Bool, email: String?, password: String?) {
        UserDefaults.standard.set(token, forKey: "authToken")
        if rememberMe, let email = email, let password = password {
            UserDefaults.standard.set(email, forKey: "rememberedEmail")
            UserDefaults.standard.set(password, forKey: "rememberedPassword")
        }
    }

    func getUserCredentials() -> (email: String, password: String)? {
        guard let email = defaults.string(forKey: "rememberedEmail"),
            let password = defaults.string(forKey: "rememberedPassword"),
            let expiryDate = defaults.object(forKey: "credentialsExpiry")
                as? Date,
            expiryDate > Date()
        else {
            return nil
        }
        return (email, password)
    }

    func clearUserCredentials() {
        defaults.removeObject(forKey: "rememberedEmail")
        defaults.removeObject(forKey: "rememberedPassword")
        defaults.removeObject(forKey: "credentialsExpiry")
    }

    func sendTokenToBackend(idToken: String, rememberMe: Bool) async throws
        -> String
    {

        let deviceId =
            await UIDevice.current.identifierForVendor?.uuidString
            ?? "unknown_device"

        let request = AuthenticateUserRequest(deviceId: deviceId)

        do {
            let response = try await vpnService.authenticate(
                token: idToken, request: request)

            let authToken = response.token

            UserDefaults.standard.set(authToken, forKey: "authToken")

            return authToken
        } catch {
            throw NSError(
                domain: "AuthError", code: -6,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Failed to authenticate: \(error.localizedDescription)"
                ]
            )
        }
    }

    private func mapAuthError(_ error: Error) -> AuthError {
        guard let error = error as NSError?, error.domain == AuthErrorDomain
        else {
            return .custom(
                NSLocalizedString(
                    "unexpected_error", comment: "Generic auth failure"))
        }

        switch error.code {
        case AuthErrorCode.userNotFound.rawValue:
            return .custom(
                NSLocalizedString(
                    "user_not_found", comment: "User does not exist"))
        case AuthErrorCode.wrongPassword.rawValue:
            return .custom(
                NSLocalizedString(
                    "wrong_password", comment: "Incorrect password"))
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .custom(
                NSLocalizedString(
                    "email_already_registered",
                    comment: "Email already registered"))
        case AuthErrorCode.networkError.rawValue:
            return .custom(
                NSLocalizedString("network_error", comment: "Network error"))
        case AuthErrorCode.userDisabled.rawValue:
            return .custom(
                NSLocalizedString(
                    "account_disabled", comment: "Account disabled"))
        default:
            return .custom(
                NSLocalizedString(
                    "unexpected_error", comment: "Authentication failed"))
        }
    }

}
