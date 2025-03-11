import SwiftUI
import FreshchatSDK

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var navigation = NavigationCoordinator()
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    @StateObject private var accountInfoViewModel = AccountInfoViewModel()
    
    @State private var isFreshchatOpened = false  // Prevents infinite loop
    
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
                                HomeView(navigation: navigation) // Keeps user on HomeView
                                    .onAppear {
                                        if !isFreshchatOpened {
                                            isFreshchatOpened = true
                                            openFreshchat()
                                        }
                                    }
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
                navigation.navigateToHome()
            } else {
                navigation.navigateToLogin()
            }
        }
    }
    
    /// **Opens Freshchat**
    private func openFreshchat() {
        guard let rootVC = getRootViewController() else { return }
        Freshchat.sharedInstance().showConversations(rootVC)

        // Start checking if Freshchat is dismissed
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.checkIfFreshchatDismissed(rootVC)
        }
    }
    
    /// **Detects if Freshchat has been closed**
    private func checkIfFreshchatDismissed(_ rootVC: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if rootVC.presentedViewController == nil {
                isFreshchatOpened = false  // Prevents reopening
                navigation.navigateToHome()
            } else {
                self.checkIfFreshchatDismissed(rootVC)
            }
        }
    }
    
    /// **Get the Root View Controller in iOS 15+**
    private func getRootViewController() -> UIViewController? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController
    }
}
