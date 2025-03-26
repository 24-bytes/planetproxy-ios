import SwiftUI
import FreshchatSDK

class NavigationCoordinator: ObservableObject {
    static let shared = NavigationCoordinator()
    @Published var path = NavigationPath()
    @Published var lastRoute: Route? = nil
    @Published var isFreshchatOpened = false
    
    func navigateToHome() {
        DispatchQueue.main.async {
            self.lastRoute = .home
            self.path.removeLast(self.path.count)
            self.path.append(Route.home)
            self.isFreshchatOpened = false
        }
    }
    
    func navigateToLogin() {
        DispatchQueue.main.async {
            self.path.removeLast(self.path.count)
            self.path.append(Route.login)
        }
    }

    func navigateToProfile() {
        DispatchQueue.main.async {
            self.path.append(Route.profile)
        }
    }
    
    func navigateToServers() {
        DispatchQueue.main.async {
            self.path.append(Route.servers)
            AnalyticsManager.shared.trackEvent(EventName.TAP.VIEW_SERVERS)
        }
    }
    
    func navigateToSubscription() {
        DispatchQueue.main.async {
            self.path.append(Route.subscription)
        }
    }
    
    func navigateToSupport() {
            DispatchQueue.main.async {
                self.lastRoute = .support
                self.path.append(Route.support)
            }
        }
    
    func openFreshchat() {
        DispatchQueue.main.async {
            if !self.isFreshchatOpened {
                self.isFreshchatOpened = true
                
                AnalyticsManager.shared.trackEvent(EventName.VIEW.CUSTOMER_SUPPORT_SCREEN)
                
                if let rootVC = UIApplication.shared
                    .connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                    .first?
                    .rootViewController {
                    Freshchat.sharedInstance().showConversations(rootVC)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.checkIfFreshchatDismissed(rootVC)
                    }
                }
            }
        }
    }

    private func checkIfFreshchatDismissed(_ rootVC: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if rootVC.presentedViewController == nil {
                self.isFreshchatOpened = false
            } else {
                self.checkIfFreshchatDismissed(rootVC)
            }
        }
    }

}
