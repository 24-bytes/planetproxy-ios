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

    private var authCheckTimer: Timer?

    private let signUpUseCase: SignUpUseCaseProtocol
    private let signInUseCase: SignInUseCaseProtocol
    private let signInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol

    init(
        signUpUseCase: SignUpUseCaseProtocol = SignUpUseCase(),
        signInUseCase: SignInUseCaseProtocol = SignInUseCase(),
        signInWithGoogleUseCase: SignInWithGoogleUseCaseProtocol = SignInWithGoogleUseCase()
    ) {
        self.signUpUseCase = signUpUseCase
        self.signInUseCase = signInUseCase
        self.signInWithGoogleUseCase = signInWithGoogleUseCase
        
        checkAuthStatus()
        startAuthCheckTimer()
    }

    private func startAuthCheckTimer() {
        authCheckTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkAuthStatus()
            }
        }
    }

    func checkAuthStatus() {
        guard let expiryDate = UserDefaults.standard.object(forKey: "tokenExpiry") as? Date else {
            print("❌ No token expiry found, logging out")
            signOut()
            return
        }

        let currentTime = Date()
        print("🔎 Checking Token Expiry: \(expiryDate) | Current Time: \(currentTime)")

        if currentTime >= expiryDate {
            print("⏳ Token Expired! Logging Out.")
            signOut()
        } else {
            self.user = Auth.auth().currentUser
            self.isAuthenticated = (self.user != nil)
            print("✅ User is still authenticated")
        }
    }

    private func storeAuthToken(_ token: String, rememberMe: Bool) {
        let expiryTime = rememberMe ? 30 * 24 * 60 * 60 : 60 // 30 days or 1 minute
        let expiryDate = Date().addingTimeInterval(Double(expiryTime))

        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.set(expiryDate, forKey: "tokenExpiry")
        self.isAuthenticated = true
    }

    func signIn(email: String, password: String, rememberMe: Bool) {
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
                let token = try await signInUseCase.execute(email: email, password: password, rememberMe: rememberMe)
                storeAuthToken(token, rememberMe: rememberMe)
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func signUp(email: String, password: String, rememberMe: Bool) {
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
                let token = try await signUpUseCase.execute(email: email, password: password, rememberMe: rememberMe)
                storeAuthToken(token, rememberMe: rememberMe)
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func signInWithGoogle(rememberMe: Bool) {
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
                
                let firebaseToken = try await authResult.user.getIDToken()
                storeAuthToken(firebaseToken, rememberMe: rememberMe)
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "authToken")
            UserDefaults.standard.removeObject(forKey: "tokenExpiry")
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
