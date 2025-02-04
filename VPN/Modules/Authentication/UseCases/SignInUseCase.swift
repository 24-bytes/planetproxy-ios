protocol SignInUseCaseProtocol {
    func execute(email: String, password: String) async throws -> String
}

class SignInUseCase: SignInUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String) async throws -> String {
        return try await authRepository.login(email: email, password: password)
    }
}
