import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

@MainActor
class AuthViewModel: ObservableObject {
    private let authRepository = AuthRepository()
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var user: User?
    @Published var errorMessage: String?
    
    init() {
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
                let token = try await authRepository.login(email: email, password: password)
                UserDefaults.standard.set(token, forKey: AppConstants.Auth.tokenKey)
                isAuthenticated = true
                user = Auth.auth().currentUser
            } catch AuthError.userNotFound {
                errorMessage = AppConstants.ErrorMessages.userNotFound
            } catch AuthError.wrongPassword {
                errorMessage = AppConstants.ErrorMessages.wrongPassword
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
                let token = try await authRepository.signup(email: email, password: password)
                UserDefaults.standard.set(token, forKey: AppConstants.Auth.tokenKey)
                isAuthenticated = true
                user = Auth.auth().currentUser
            } catch AuthError.emailAlreadyInUse {
                errorMessage = AppConstants.ErrorMessages.emailInUse
            } catch {
                errorMessage = AppConstants.ErrorMessages.unknownError
            }
            
            isLoading = false
        }
    }
    
    func signInWithGoogle() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                guard let clientID = FirebaseApp.app()?.options.clientID else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get client ID"])
                }
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first,
                      let rootViewController = window.rootViewController else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller found"])
                }
                
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
                
                let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                
                guard let idToken = gidSignInResult.user.idToken?.tokenString else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No ID token found"])
                }
                
                let token = try await authRepository.signInWithGoogle(idToken: idToken)
                UserDefaults.standard.set(token, forKey: AppConstants.Auth.tokenKey)
                isAuthenticated = true
                self.user = Auth.auth().currentUser
                
            } catch {
                errorMessage = AppConstants.ErrorMessages.unknownError
            }
            
            isLoading = false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: AppConstants.Auth.tokenKey)
            self.user = nil
            self.isAuthenticated = false
        } catch {
            self.errorMessage = AppConstants.ErrorMessages.unknownError
        }
    }
    
    func resetPassword(email: String) {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
            } catch {
                errorMessage = AppConstants.ErrorMessages.unknownError
            }
            
            isLoading = false
        }
    }
}
