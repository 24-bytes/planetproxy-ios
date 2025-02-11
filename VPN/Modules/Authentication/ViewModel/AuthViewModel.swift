import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var loadingButtonType: AuthButtonType? = nil
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var rememberedEmail: String = ""
    @Published var rememberedPassword: String = ""

    private let authRepository: AuthRepositoryProtocol
    private let signUpUseCase: SignUpUseCaseProtocol
    private let signInUseCase: SignInUseCaseProtocol
    private let signInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol
    private let rememberUserUseCase: RememberUserUseCaseProtocol

    enum AuthButtonType {
        case signIn, signUp, googleSignIn
    }

    init(
        authRepository: AuthRepositoryProtocol = AuthRepository(),
        signUpUseCase: SignUpUseCaseProtocol = SignUpUseCase(),
        signInUseCase: SignInUseCaseProtocol = SignInUseCase(),
        signInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol =
            SignInWithGoogleUseCase(),
        rememberUserUseCase: RememberUserUseCaseProtocol = RememberUserUseCase()
    ) {
        self.authRepository = authRepository
        self.signUpUseCase = signUpUseCase
        self.signInUseCase = signInUseCase
        self.signInWithGoogleUseCase = signInWithGoogleUseCase
        self.rememberUserUseCase = rememberUserUseCase

        loadAuthState()
        loadRememberedCredentials()  // ✅ Load credentials at launch
    }

    //todo:// Move this to usecase
    func loadAuthState() {
        if let authToken = UserDefaults.standard.string(forKey: "authToken"),
            let expiryDate = UserDefaults.standard.object(forKey: "tokenExpiry")
                as? Date,
            expiryDate > Date()
        {
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }

    func loadRememberedCredentials() {
        if let credentials = rememberUserUseCase.getUserCredentials() {
            rememberedEmail = credentials.email
            rememberedPassword = credentials.password
        }
    }

    func signIn(email: String, password: String, rememberMe: Bool) {
        guard FormValidator.isValidEmail(email) else {
            errorMessage = NSLocalizedString(
                "invalid_email", comment: "Invalid email format")
            clearErrorMessageAfterDelay()
            return
        }
        guard FormValidator.isNotEmpty(password) else {
            errorMessage = NSLocalizedString(
                "empty_password", comment: "Empty password error")
            clearErrorMessageAfterDelay()
            return
        }

        Task {
            DispatchQueue.main.async { self.loadingButtonType = .signIn }
            errorMessage = nil
            do {
                let token = try await signInUseCase.execute(
                    email: email, password: password, rememberMe: rememberMe)
                authRepository.storeAuthToken(
                    token, rememberMe: rememberMe, email: email,
                    password: password)

                if !rememberMe {
                    rememberUserUseCase.clearUserCredentials()
                    rememberedEmail = ""
                    rememberedPassword = ""
                }

                self.isAuthenticated = true
            } catch let authError as AuthError {
                self.errorMessage = authError.localizedDescription
                clearErrorMessageAfterDelay()
            } catch {
                self.errorMessage = NSLocalizedString(
                    "unexpected_error",
                    comment: "Unexpected error. Please try again.")
                clearErrorMessageAfterDelay()
            }
            DispatchQueue.main.async { self.loadingButtonType = nil }
        }
    }

    func signOut() {
        do {
            //todo:// Create a signoutUseCase and move the logic in useCase
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "authToken")
            UserDefaults.standard.removeObject(forKey: "tokenExpiry")

            rememberedEmail = ""
            rememberedPassword = ""
            self.isAuthenticated = false
            loadRememberedCredentials()
        } catch {
            errorMessage = NSLocalizedString(
                "unexpected_error",
                comment: "Unexpected error. Please try again.")
        }
    }

    func signUp(email: String, password: String, rememberMe: Bool) {
        guard FormValidator.isValidEmail(email) else {
            errorMessage = NSLocalizedString(
                "invalid_email", comment: "Invalid email format")
            clearErrorMessageAfterDelay()
            return
        }
        guard FormValidator.isValidPassword(password) else {
            errorMessage = NSLocalizedString(
                "password_requirement",
                comment:
                    "Password must be at least 8 characters, include 1 uppercase letter, 1 digit, and 1 special character"
            )
            clearErrorMessageAfterDelay()
            return
        }

        Task {
            DispatchQueue.main.async { self.loadingButtonType = .signUp }
            errorMessage = nil
            do {
                let token = try await signUpUseCase.execute(
                    email: email, password: password, rememberMe: rememberMe)
                authRepository.storeAuthToken(
                    token, rememberMe: rememberMe, email: email,
                    password: password)

                self.isAuthenticated = true
            } catch let authError as AuthError {
                self.errorMessage = authError.localizedDescription
                clearErrorMessageAfterDelay()
            } catch {
                self.errorMessage = NSLocalizedString(
                    "unexpected_error",
                    comment: "Unexpected error. Please try again.")
                clearErrorMessageAfterDelay()
            }
            DispatchQueue.main.async { self.loadingButtonType = nil }
        }
    }

    func loadRememberedUser() -> (email: String, password: String)? {
        return rememberUserUseCase.getUserCredentials()
    }

    func loadRememberedUser() {
        if let credentials = rememberUserUseCase.getUserCredentials() {
            signIn(
                email: credentials.email, password: credentials.password,
                rememberMe: true)
        }
    }

    func signInWithGoogle(rememberMe: Bool) {
        Task {
            DispatchQueue.main.async { self.loadingButtonType = .googleSignIn }
            errorMessage = nil

            do {
                let firebaseToken = try await signInWithGoogleUseCase.execute(
                    rememberMe: rememberMe)
                authRepository.storeAuthToken(
                    firebaseToken, rememberMe: rememberMe, email: nil,
                    password: nil)

                self.isAuthenticated = true
                DispatchQueue.main.async {
                    NavigationCoordinator.shared.navigateToHome()
                }
            } catch {
                self.errorMessage = error.localizedDescription
                clearErrorMessageAfterDelay()
            }

            DispatchQueue.main.async { self.loadingButtonType = nil }
        }
    }

    func resetPassword(email: String) {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                errorMessage = "Password reset link sent to your email."
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func clearErrorMessageAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.errorMessage = nil
        }
    }
}
