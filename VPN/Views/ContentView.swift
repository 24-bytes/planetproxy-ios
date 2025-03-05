import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var navigation = NavigationCoordinator()
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    @StateObject private var accountInfoViewModel = AccountInfoViewModel()

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
                            case .accountInfo:
                                AccountInfoView()
                            case .settings:
                                SettingsView()
                            case .faq:
                                FAQView()
                            case .support:
                                SupportView()
                            case .rateUs:
                                RateUsView()
                            case .privacyPolicy:
                                PrivacyPolicyView()
                            case .subscription:
                                SubscriptionView()
                            case .servers:
                                VPNServersView(navigation: navigation)
                            default:
                                HomeView(navigation: navigation)
                            }
                        }
                }
            }

            SidebarView(
                userInfoModel: accountInfoViewModel,
                navigation: navigation
            )
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
