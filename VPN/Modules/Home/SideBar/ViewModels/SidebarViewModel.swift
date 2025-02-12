import SwiftUI

@MainActor
class SidebarViewModel: ObservableObject {
    @Published var isSidebarOpen = false
    @Published var selectedDestination: SidebarDestination? = nil

    let menuItems: [SidebarMenuItem] = [
        SidebarMenuItem(title: "Account information", icon: "person", destination: .accountInfo),
        SidebarMenuItem(title: "Settings", icon: "gearshape", destination: .settings),
        SidebarMenuItem(title: "FAQ", icon: "questionmark.circle", destination: .faq),
        SidebarMenuItem(title: "Support", icon: "message", destination: .support),
        SidebarMenuItem(title: "Rate us", icon: "star", destination: .rateUs),
        SidebarMenuItem(title: "Privacy policy", icon: "globe", destination: .privacyPolicy)
    ]

    func selectMenuItem(_ destination: SidebarDestination, navigation: NavigationCoordinator, authViewModel: AuthViewModel) {
        Task { @MainActor in
            if destination == .accountInfo && !authViewModel.isAuthenticated {
                navigation.navigateToLogin() // Redirect to Login
            } else {
                selectedDestination = destination
                navigation.path.append(mapDestinationToRoute(destination)) // ✅ Convert destination to Route
            }
            isSidebarOpen = false
        }
    }

    // ✅ Converts SidebarDestination to Route Enum
    func mapDestinationToRoute(_ destination: SidebarDestination) -> Route {
        switch destination {
        case .accountInfo: return .accountInfo
        case .settings: return .settings
        case .faq: return .faq
        case .support: return .support
        case .rateUs: return .rateUs
        case .privacyPolicy: return .privacyPolicy
        }
    }
}
