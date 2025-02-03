import Foundation
import Firebase
import FirebaseAuth
import UIKit

class AuthRepository {
    private let authService = AuthService.shared
    private let defaults = UserDefaults.standard
    
    func login(email: String, password: String) async throws -> String {
        do {
            let idToken = try await authService.signIn(email: email, password: password)
            let token = try await authService.verifyTokenOnBackend(idToken: idToken, deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "unknown")
            defaults.set(token, forKey: "authToken")
            return token
        } catch let error as NSError {
            if error.domain == AuthErrorDomain {
                switch error.code {
                case AuthErrorCode.userNotFound.rawValue:
                    throw AuthError.userNotFound
                case AuthErrorCode.wrongPassword.rawValue:
                    throw AuthError.wrongPassword
                default:
                    throw AuthError.unknown(error)
                }
            }
            throw error
        }
    }
    
    func signup(email: String, password: String) async throws -> String {
        do {
            let idToken = try await authService.signUp(email: email, password: password)
            let token = try await authService.verifyTokenOnBackend(idToken: idToken, deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "unknown")
            defaults.set(token, forKey: "authToken")
            return token
        } catch let error as NSError {
            if error.domain == AuthErrorDomain {
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    throw AuthError.emailAlreadyInUse
                default:
                    throw AuthError.unknown(error)
                }
            }
            throw error
        }
    }
    
    func signInWithGoogle(idToken: String) async throws -> String {
        let firebaseToken = try await authService.signInWithGoogle(idToken: idToken)
        let token = try await authService.verifyTokenOnBackend(idToken: firebaseToken, deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "unknown")
        defaults.set(token, forKey: "authToken")
        return token
    }
}

enum AuthError: Error {
    case userNotFound
    case wrongPassword
    case emailAlreadyInUse
    case unknown(Error)
}
