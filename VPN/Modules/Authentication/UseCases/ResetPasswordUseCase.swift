//
//  ResetPasswordUseCase.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

protocol ResetPasswordUseCaseProtocol {
    func execute(email: String) async throws
}

class ResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func execute(email: String) async throws {
        try await authRepository.resetPassword(email: email)
    }
}
