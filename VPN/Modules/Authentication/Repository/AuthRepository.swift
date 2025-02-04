//
//  AuthRepository.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import FirebaseAuth
import GoogleSignIn
import UIKit

protocol AuthRepositoryProtocol {
    func signInWithGoogle(idToken: String) async throws -> String
    func login(email: String, password: String) async throws -> String
    func signup(email: String, password: String) async throws -> String
    func signOut() throws
    func resetPassword(email: String) async throws
}

class AuthRepository: AuthRepositoryProtocol {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func signInWithGoogle(idToken: String) async throws -> String {
        do {
            // Create Google Credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: "")

            // Sign in with Firebase using Google credentials
            let authResult = try await Auth.auth().signIn(with: credential)

            // Retrieve Firebase ID Token
            let firebaseToken = try await authResult.user.getIDToken()

            // Store token in UserDefaults
            defaults.set(firebaseToken, forKey: "authToken")

            return firebaseToken
        } catch {
            throw AuthError.unknown(error)
        }
    }

    func login(email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return try await handleTokenVerification(result.user)
        } catch {
            throw mapAuthError(error)
        }
    }

    func signup(email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return try await handleTokenVerification(result.user)
        } catch {
            throw mapAuthError(error)
        }
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
            defaults.removeObject(forKey: "authToken")
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

    // MARK: - Private Helper Methods
    private func handleTokenVerification(_ user: FirebaseAuth.User) async throws -> String {
        let token = try await user.getIDToken()
        defaults.set(token, forKey: "authToken")
        return token
    }

    private func mapAuthError(_ error: Error) -> AuthError {
        guard let error = error as NSError?, error.domain == AuthErrorDomain else {
            return .unknown(error)
        }

        switch error.code {
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        default:
            return .unknown(error)
        }
    }
}
