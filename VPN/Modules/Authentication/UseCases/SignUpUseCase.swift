//
//  SignUpUseCase.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

protocol SignUpUseCaseProtocol {
    func execute(email: String, password: String, rememberMe: Bool) async throws -> String
}

class SignUpUseCase: SignUpUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String, rememberMe: Bool) async throws -> String {
        return try await authRepository.signup(email: email, password: password, rememberMe: rememberMe)
    }
}

