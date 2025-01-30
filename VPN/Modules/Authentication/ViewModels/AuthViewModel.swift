import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        checkAuthenticationStatus()
    }

    func login(username: String, password: String) {
        // Simulating an API call with a delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            DispatchQueue.main.async {
                if username == "admin" && password == "password" {
                    self.isAuthenticated = true
                    self.errorMessage = nil
                } else {
                    self.errorMessage = "Invalid credentials"
                }
            }
        }
    }

    func logout() {
        isAuthenticated = false
    }

    private func checkAuthenticationStatus() {
        // Load authentication status from UserDefaults or a secure storage
        isAuthenticated = false // Replace with real logic if needed
    }
}
