import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var navigation = NavigationCoordinator()

    var body: some View {
        NavigationStack(path: $navigation.path) {
            HomeView(navigation: navigation)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .login:
                        LoginView()
                    case .home:
                        HomeView(navigation: navigation)
                    case .profile:
                        ProfileView()
                    }
                }
        }
    }
}
