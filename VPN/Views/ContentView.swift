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
                            case .accountInfo, .profile:
                                if authViewModel.isAuthenticated {
                                    ProfileView()
                                } else {
                                    LoginView()
                                        .onAppear {
                                            navigation.navigateToLogin() // ✅ Redirect to Login
                                        }
                                }
                            case .settings:
                                SettingsView()
                            case .faq:
                                FAQView()
                            case .support:
                                SupportView()
                            case .rateUs:
                                RateUsView()
                            case .privacyPolicy:
                                VPNServersView()
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
                        let mappedRoute = sidebarViewModel.mapDestinationToRoute(newRoute)
                        navigation.path.append(mappedRoute)
                    }
                }
        
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                navigation.navigateToHome() // ✅ Redirect to Home after login
            } else {
                navigation.navigateToLogin()
            }
        }
    }
}
