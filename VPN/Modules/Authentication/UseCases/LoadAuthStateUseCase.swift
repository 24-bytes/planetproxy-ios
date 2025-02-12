//
//  LoadAuthStateUseCase.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 12/02/25.
//

import Foundation

protocol LoadAuthStateUseCaseProtocol {
    func execute() -> Bool
}

class LoadAuthStateUseCase: LoadAuthStateUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func execute() -> Bool {
        return authRepository.loadAuthState()
    }
}
