import SwiftUI
import FreshchatSDK
import Network

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var navigation = NavigationCoordinator()
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    @StateObject private var accountInfoViewModel = AccountInfoViewModel()
    @StateObject private var networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        ZStack {
          
                NavigationStack(path: $navigation.path) {
                    VStack {
                        HomeView(navigation: navigation, authViewModel: authViewModel)
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .login:
                                    LoginView()
                                case .home:
                                    HomeView(navigation: navigation, authViewModel: authViewModel)
                                case .accountInfo:
                                    AccountInfoView(navigation: navigation)
                                case .settings:
                                    SettingsView(navigation: navigation)
                                case .faq:
                                    FAQView(navigation: navigation)
                                case .rateUs:
                                    RateUsView()
                                case .privacyPolicy:
                                    PrivacyPolicyView(navigation: navigation)
                                case .subscription:
                                    SubscriptionView(navigation: navigation)
                                case .servers:
                                    VPNServersView(navigation: navigation)
                                default:
                                    HomeView(navigation: navigation, authViewModel: authViewModel)
                                }
                            }
                    }
                }
            if networkMonitor.isInitialized && !networkMonitor.isDataConnected {
                           NoInternetView()
                       }

            SidebarView(
                userInfoModel: accountInfoViewModel,
                navigation: navigation
            )
        }.onAppear {
            networkMonitor.refreshStatus()
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                navigation.navigateToHome()
            }
        }
    }
}
