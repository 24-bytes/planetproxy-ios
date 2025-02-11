import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var navigation = NavigationCoordinator()
    @EnvironmentObject var sidebarViewModel: SidebarViewModel

    var body: some View {
        ZStack {
            NavigationStack(path: $navigation.path) {
                VStack {
                    HomeView(navigation: navigation)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .login:
                                LoginView()
                            case .home:
                                HomeView(navigation: navigation)
                            case .settings:
                                ProfileView()
                            case .accountInfo, .profile:
                                if authViewModel.isAuthenticated {
                                    ProfileView()
                                } else {
                                    LoginView()
                                        .onAppear {
                                            navigation.navigateToLogin() // ✅ Redirect to Login
                                        }
                                }
                            default:
                                ProfileView()
                            }
                        }
                }
            }

            SidebarView()
        }
        .onChange(of: sidebarViewModel.selectedDestination) { _ in
            if let newRoute = sidebarViewModel.selectedDestination {
                if newRoute == .accountInfo, !authViewModel.isAuthenticated {
                    navigation.navigateToLogin()
                } else {
                    navigation.path.append(newRoute)
                }
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                navigation.navigateToHome() // ✅ Redirect to Home after login
            }
        }
    }
}
