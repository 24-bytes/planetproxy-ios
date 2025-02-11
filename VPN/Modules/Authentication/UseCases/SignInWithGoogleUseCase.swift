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

        guard
            let windowScene = await UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
            let rootViewController = await windowScene.windows.first?
                .rootViewController
        else {
            throw NSError(
                domain: "AuthError", code: -2,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Cannot find root view controller"
                ])
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController)

        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(
                domain: "AuthError", code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Missing ID Token"])
        }

        return try await authRepository.signInWithGoogle(
            idToken: idToken, rememberMe: rememberMe)
    }
}
