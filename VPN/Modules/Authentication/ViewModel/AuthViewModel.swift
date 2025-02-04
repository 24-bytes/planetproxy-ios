import SwiftUI
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    private let signInUseCase: SignInUseCaseProtocol
    private let signUpUseCase: SignUpUseCaseProtocol
    private let signInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol
    private let signOutUseCase: SignOutUseCaseProtocol
    private let resetPasswordUseCase: ResetPasswordUseCaseProtocol

    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var user: User?
    @Published var errorMessage: String?

    init(
        signInUseCase: SignInUseCaseProtocol = SignInUseCase(),
        signUpUseCase: SignUpUseCaseProtocol = SignUpUseCase(),
        signInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol = SignInWithGoogleUseCase(),
        signOutUseCase: SignOutUseCaseProtocol = SignOutUseCase(),
        resetPasswordUseCase: ResetPasswordUseCaseProtocol = ResetPasswordUseCase()
    ) {
        self.signInUseCase = signInUseCase
        self.signUpUseCase = signUpUseCase
        self.signInWithGoogleUseCase = signInWithGoogleUseCase
        self.signOutUseCase = signOutUseCase
        self.resetPasswordUseCase = resetPasswordUseCase
        checkAuthStatus()
    }

    private func checkAuthStatus() {
        if let _ = UserDefaults.standard.string(forKey: AppConstants.Auth.tokenKey) {
            self.isAuthenticated = true
        }
    }

    func signIn(email: String, password: String) {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let token = try await signInUseCase.execute(email: email, password: password)
                UserDefaults.standard.set(token, forKey: AppConstants.Auth.tokenKey)
                isAuthenticated = true
                user = Auth.auth().currentUser
            } catch {
                errorMessage = AppConstants.ErrorMessages.unknownError
            }

            isLoading = false
        }
    }

    func signUp(email: String, password: String) {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let token = try await signUpUseCase.execute(email: email, password: password)
                UserDefaults.standard.set(token, forKey: AppConstants.Auth.tokenKey)
                isAuthenticated = true
                user = Auth.auth().currentUser
            } catch {
                errorMessage = AppConstants.ErrorMessages.unknownError
            }

            isLoading = false
        }
    }


    func signOut() {
        do {
            try signOutUseCase.execute()
            UserDefaults.standard.removeObject(forKey: AppConstants.Auth.tokenKey)
            user = nil
            isAuthenticated = false
        } catch {
            errorMessage = AppConstants.ErrorMessages.unknownError
        }
    }

    func resetPassword(email: String) {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                try await resetPasswordUseCase.execute(email: email)
            } catch {
                errorMessage = AppConstants.ErrorMessages.unknownError
            }
            isLoading = false
        }
    }
}
