//
//  SignOutUseCase.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

protocol SignOutUseCaseProtocol {
    func execute() throws
}

class SignOutUseCase: SignOutUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func execute() throws {
        try authRepository.signOut()
    }
}
