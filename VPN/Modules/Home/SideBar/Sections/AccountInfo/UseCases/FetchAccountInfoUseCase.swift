//
//  FetchAccountInfoUseCase.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 13/02/25.
//

import Foundation

protocol FetchAccountInfoUseCaseProtocol {
    func execute() async throws -> AccountInfoModel
}

class FetchAccountInfoUseCase: FetchAccountInfoUseCaseProtocol {
    private let repository: AccountRepositoryProtocol

    init(repository: AccountRepositoryProtocol = AccountRepository()) {
        self.repository = repository
    }

    func execute() async throws -> AccountInfoModel {
        return try await repository.fetchUserInfo()
    }
}
