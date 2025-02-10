protocol RememberUserUseCaseProtocol {
    func getUserCredentials() -> (email: String, password: String)?
    func clearUserCredentials()
}

class RememberUserUseCase: RememberUserUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func getUserCredentials() -> (email: String, password: String)? {
        return authRepository.getUserCredentials()
    }
    
    func clearUserCredentials() {
        return authRepository.clearUserCredentials()
    }
}

