import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var navigation = NavigationCoordinator()

    var body: some View {
        NavigationStack(path: $navigation.path) {
            if authViewModel.isAuthenticated {
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .login:
                            LoginView()
                        case .home:
                            HomeView()
                        case .profile:
                            ProfileView()
                        }
                    }
            } else {
                LoginView()
            }
        }
        .onAppear {
            print("🔄 Checking authentication status on launch")
            Task { @MainActor in
                authViewModel.checkAuthStatus()
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { oldValue, newValue in
            if newValue {
                print("✅ Navigating to Home Page")
                navigation.reset() // ✅ Clears previous navigation stack
                navigation.path.append(.home)
            }
        }
    }
}
