import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var user: User?
    @Published var errorMessage: String?

    init() {
        checkAuthStatus()
    }

    private func checkAuthStatus() {
        self.user = Auth.auth().currentUser
        self.isAuthenticated = (user != nil)
    }

    func signIn(email: String, password: String) {
           // Validate email & password before making API call
           guard FormValidator.isValidEmail(email) else {
               errorMessage = "Invalid email format"
               return
           }

          guard FormValidator.isNotEmpty(password) else {
                errorMessage = "Password cannot be empty"
                return
          }

           Task {
               isLoading = true
               errorMessage = nil
               do {
                   let result = try await Auth.auth().signIn(withEmail: email, password: password)
                   self.user = result.user
                   self.isAuthenticated = true
               } catch {
                   self.errorMessage = error.localizedDescription
               }
               isLoading = false
           }
       }

       func signUp(email: String, password: String) {
           guard FormValidator.isValidEmail(email) else {
               errorMessage = "Invalid email format"
               return
           }

           guard FormValidator.isValidPassword(password) else {
               errorMessage = "Password must be at least 8 characters, include 1 uppercase letter, 1 digit, and 1 special character"
               return
           }

           Task {
               isLoading = true
               errorMessage = nil
               do {
                   let result = try await Auth.auth().createUser(withEmail: email, password: password)
                   self.user = result.user
                   self.isAuthenticated = true
               } catch {
                   self.errorMessage = error.localizedDescription
               }
               isLoading = false
           }
       }
    
    private func showError(_ message: String) {
            self.errorMessage = message
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // Auto-hide error after 4 seconds
                self.errorMessage = nil
            }
        }

    func signInWithGoogle() {
        Task {
            isLoading = true
            errorMessage = nil

            guard let clientID = FirebaseApp.app()?.options.clientID else {
                self.errorMessage = "Missing Client ID"
                isLoading = false
                return
            }

            guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = await windowScene.windows.first?.rootViewController else {
                      self.errorMessage = "Cannot find root view controller"
                      isLoading = false
                      return
                  }

            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

                guard let idToken = result.user.idToken?.tokenString else {
                    self.errorMessage = "Missing ID Token"
                    isLoading = false
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: "")
                let authResult = try await Auth.auth().signIn(with: credential)

                self.user = authResult.user
                self.isAuthenticated = true
            } catch {
                self.errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch {
            self.errorMessage = "Sign out failed"
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

}

