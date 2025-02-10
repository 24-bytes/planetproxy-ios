import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
       @Published var isLoading = false
       @Published var user: User?
       @Published var errorMessage: String?
        @Published var rememberedEmail: String = ""
        @Published var rememberedPassword: String = ""

       private let signUpUseCase: SignUpUseCaseProtocol
       private let signInUseCase: SignInUseCaseProtocol
       private let signInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol
       private let rememberUserUseCase: RememberUserUseCaseProtocol

       init(
           signUpUseCase: SignUpUseCaseProtocol = SignUpUseCase(),
           signInUseCase: SignInUseCaseProtocol = SignInUseCase(),
           signInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol = SignInWithGoogleUseCase(),
           rememberUserUseCase: RememberUserUseCaseProtocol = RememberUserUseCase()
       ) {
           self.signUpUseCase = signUpUseCase
           self.signInUseCase = signInUseCase
           self.signInWithGoogleUseCase = signInWithGoogleUseCase
           self.rememberUserUseCase = rememberUserUseCase
       
           loadAuthState()
           loadRememberedCredentials() // ✅ Load credentials at launch
       }

    func loadAuthState() {
            if let authToken = UserDefaults.standard.string(forKey: "authToken"),
               let expiryDate = UserDefaults.standard.object(forKey: "tokenExpiry") as? Date,
               expiryDate > Date() {
                isAuthenticated = true
            } else {
                isAuthenticated = false
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
        errorMessage = NSLocalizedString("invalid_email", comment: "Invalid email format") // 🔹 Localized
        clearErrorMessageAfterDelay()
        return
    }
    guard FormValidator.isNotEmpty(password) else {
        errorMessage = NSLocalizedString("empty_password", comment: "Empty password error") // 🔹 Localized
        clearErrorMessageAfterDelay()
        return
    }

        Task {
            isLoading = true
            errorMessage = nil
            do {
                let token = try await signInUseCase.execute(email: email, password: password, rememberMe: rememberMe)
                storeAuthToken(token, rememberMe: rememberMe, email: email, password: password)

                // ✅ If user logs in but unchecks "Remember Me", clear stored credentials
                if !rememberMe {
                    rememberUserUseCase.clearUserCredentials()
                    rememberedEmail = ""
                    rememberedPassword = ""
                }

                isAuthenticated = true
            } catch let authError as AuthError {
                self.errorMessage = authError.localizedDescription // ✅ Uses mapped error
                clearErrorMessageAfterDelay()
            } catch {
                self.errorMessage = "Unexpected error. Please try again." // ✅ Fallback message
                clearErrorMessageAfterDelay()
            }
            isLoading = false
        }
    }


        func signOut() {
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "tokenExpiry")

                rememberedEmail = ""
                rememberedPassword = ""
                isAuthenticated = false
                loadRememberedCredentials()
            } catch {
                errorMessage = "Sign out failed"
            }
        }

       func signUp(email: String, password: String, rememberMe: Bool) {
           guard FormValidator.isValidEmail(email) else {
        errorMessage = NSLocalizedString("invalid_email", comment: "Invalid email format") // 🔹 Localized
        clearErrorMessageAfterDelay()
        return
    }
    guard FormValidator.isValidPassword(password) else {
        errorMessage = NSLocalizedString("password_requirement", comment: "Password must be at least 8 characters, include 1 uppercase letter, 1 digit, and 1 special character") // 🔹 Localized
        clearErrorMessageAfterDelay()
        return
    }


           Task {
               isLoading = true
               errorMessage = nil
               do {
                   let token = try await signUpUseCase.execute(email: email, password: password, rememberMe: rememberMe)
                   storeAuthToken(token, rememberMe: rememberMe, email: email, password: password)
               } catch let authError as AuthError {
                   self.errorMessage = authError.localizedDescription // ✅ Uses mapped error
                   clearErrorMessageAfterDelay()
               } catch {
                   self.errorMessage = "Unexpected error. Please try again." // ✅ Fallback message
                   clearErrorMessageAfterDelay()
               }
               isLoading = false
           }
       }

       func storeAuthToken(_ token: String, rememberMe: Bool, email: String? = nil, password: String? = nil) {
           let expiryTime = rememberMe ? 30 * 24 * 60 * 60 : 24 * 60 * 60
           let expiryDate = Date().addingTimeInterval(Double(expiryTime))

           UserDefaults.standard.set(token, forKey: "authToken")
           UserDefaults.standard.set(expiryDate, forKey: "tokenExpiry")

           if rememberMe, let email = email, let password = password {
               UserDefaults.standard.set(email, forKey: "rememberedEmail")
               UserDefaults.standard.set(password, forKey: "rememberedPassword")
           }

           print("✅ Token stored. Expiry: \(expiryDate)")
       }

       func loadRememberedUser() -> (email: String, password: String)? {
           return rememberUserUseCase.getUserCredentials()
       }

        func loadRememberedUser() {
            if let credentials = rememberUserUseCase.getUserCredentials() {
                signIn(email: credentials.email, password: credentials.password, rememberMe: true)
            }
        }

    func signInWithGoogle(rememberMe: Bool) {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let firebaseToken = try await signInWithGoogleUseCase.execute(rememberMe: rememberMe)
                storeAuthToken(firebaseToken, rememberMe: rememberMe)

                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    NavigationCoordinator.shared.navigateToHome()
                }
            } catch {
                self.errorMessage = error.localizedDescription
                clearErrorMessageAfterDelay()
            }

            isLoading = false
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

