import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var navigation = NavigationCoordinator()
    

    var body: some View {
        NavigationStack(path: $navigation.path) {
            if authViewModel.isAuthenticated {
                WelcomeView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .login:
                            LoginView()
                        case .home:
                            WelcomeView()
                        case .profile:
                            ProfileView()
                        }
                    }
            } else {
                LoginView()
            }
        }
    }
}
