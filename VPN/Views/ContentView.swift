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

            // Sidebar
            SidebarView(
                userInfoModel: accountInfoViewModel,
                navigation: navigation
            )
            .offset(x: sidebarViewModel.isSidebarOpen ? 0 : -UIScreen.main.bounds.width * 0.75)
            .animation(.easeInOut, value: sidebarViewModel.isSidebarOpen)
        }
        .onAppear {
            networkMonitor.refreshStatus()
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                navigation.navigateToHome()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        if navigation.path.isEmpty {
                            sidebarViewModel.isSidebarOpen = true // ✅ Open sidebar only if on HomeView
                        } else {
                            if navigation.path.count > 1 {
                                navigation.path.removeLast() // ✅ Navigate back in other views
                            } else {
                                navigation.navigateToHome()
                            }
                        }
                    }
                }
        )
    }
}

