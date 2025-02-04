//
//  SignInWithGoogleUseCase.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import FirebaseAuth
import GoogleSignIn
import Firebase
import UIKit

protocol SignInWithGoogleUseCaseProtocol {
    func execute() async throws -> String
}

class SignInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func execute() async throws -> String {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Client ID"])
        }

        // Get the root view controller
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = await windowScene.windows.first?.rootViewController else {
                  throw NSError(domain: "AuthError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Cannot find root view controller"])
              }

        // Configure Google Sign-In
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Perform Google Sign-In
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        // Get Google ID Token
        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "AuthError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Missing ID Token"])
        }

        // Authenticate and get Firebase Token
        return try await authRepository.signInWithGoogle(idToken: idToken)
    }
}
