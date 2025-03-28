import SwiftUI

@MainActor
class SidebarViewModel: ObservableObject {
    @Published var isSidebarOpen = false
    @Published var selectedDestination: SidebarDestination? = nil

    let menuItems: [SidebarMenuItem] = [
        SidebarMenuItem(title: "Account information",key:"account_info", icon: "person", destination: .accountInfo),
        SidebarMenuItem(title: "Servers",key:"servers", icon: "shield", destination: .servers),
        SidebarMenuItem(title: "Settings",key:"settings", icon: "gearshape", destination: .settings),
        SidebarMenuItem(title: "FAQ",key:"faq", icon: "questionmark.circle", destination: .faq),
        SidebarMenuItem(title: "Rate us",key:"rate_us", icon: "star", destination: .rateUs),
        SidebarMenuItem(title: "Privacy policy",key:"privacy_policy", icon: "globe", destination: .privacyPolicy)
    ]

    func selectMenuItem(_ destination: SidebarDestination, navigation: NavigationCoordinator, authViewModel: AuthViewModel) {
        Task { @MainActor in
            if destination == .accountInfo && !authViewModel.isAuthenticated {
                navigation.navigateToLogin()
                
                // ✅ Track when user taps on "Login" from the sidebar
                AnalyticsManager.shared.trackEvent(EventName.TAP.DASHBOARD_NAV_LOGIN)
            } else {
                selectedDestination = destination
                navigation.path.append(mapDestinationToRoute(destination))
                
                // ✅ Track Sidebar Menu Selections
                switch destination {
                case .accountInfo:
                    AnalyticsManager.shared.trackEvent(EventName.TAP.ACCOUNT_INFORMATION)
                case .settings:
                    AnalyticsManager.shared.trackEvent(EventName.TAP.DASHBOARD_NAV_SETTINGS)
                case .rateUs:
                    AnalyticsManager.shared.trackEvent(EventName.TAP.DASHBOARD_NAV_RATE_US)
                case .privacyPolicy:
                    AnalyticsManager.shared.trackEvent(EventName.TAP.DASHBOARD_NAV_PRIVACY_POLICY)
                default:
                    break
                }
            }
            isSidebarOpen = false
        }
    }

    func mapDestinationToRoute(_ destination: SidebarDestination) -> Route {
        switch destination {
        case .accountInfo: return .accountInfo
        case .servers: return .servers
        case .settings: return .settings
        case .faq: return .faq
        case .support: return .support
        case .rateUs: return .rateUs
        case .privacyPolicy: return .privacyPolicy
        }
    }
}
