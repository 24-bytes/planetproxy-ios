//
//  SignInWithGoogleUseCase.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Firebase
import FirebaseAuth
import GoogleSignIn
import UIKit

protocol SignInWithGoogleUseCaseProtocol {
    func execute(rememberMe: Bool) async throws -> String
}

class SignInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    
    func execute(rememberMe: Bool) async throws -> String {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(
                domain: "AuthError", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Missing Client ID"])
        }

        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = await windowScene.windows.first?.rootViewController else {
            throw NSError(
                domain: "AuthError", code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Cannot find root view controller"])
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Capture `authRepository` outside the closure to avoid `self` issues
        let authRepo = self.authRepository

        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let idToken = result?.user.idToken?.tokenString else {
                        continuation.resume(throwing: NSError(
                            domain: "AuthError", code: -3,
                            userInfo: [NSLocalizedDescriptionKey: "Missing ID Token"]))
                        return
                    }

                    Task {
                        do {
                            let token = try await authRepo.signInWithGoogle(
                                idToken: idToken, rememberMe: rememberMe)
                            continuation.resume(returning: token)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }
    }



}
