import Foundation
import FirebaseAuth
import GoogleSignIn
import UIKit

public final class AuthService {
    public static let shared = AuthService()
    private init() {}
    
    public func signIn(email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let idToken = try await result.user.getIDToken()
            return idToken
        } catch {
            throw error
        }
    }
    
    public func signUp(email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let idToken = try await result.user.getIDToken()
            return idToken
        } catch {
            throw error
        }
    }
    
    public func signInWithGoogle(idToken: String) async throws -> String {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: "")
        let result = try await Auth.auth().signIn(with: credential)
        return try await result.user.getIDToken()
    }
    
    public func verifyTokenOnBackend(idToken: String, deviceId: String) async throws -> String {
        let url = URL(string: "\(AppConstants.API_URL)/api/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(idToken, forHTTPHeaderField: "Authorization")
        
        let body = ["deviceId": deviceId]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTP Error", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let responseData = json["data"] as? [String: Any],
              let token = responseData["token"] as? String else {
            throw NSError(domain: "Invalid Response", code: -1)
        }
        
        return token
    }
}
