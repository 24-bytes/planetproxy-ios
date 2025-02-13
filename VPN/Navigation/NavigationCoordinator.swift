import SwiftUI

class NavigationCoordinator: ObservableObject {
    static let shared = NavigationCoordinator()
    @Published var path = NavigationPath()
    
    func navigateToHome() {
        DispatchQueue.main.async {
            self.path.removeLast(self.path.count)
            self.path.append(Route.home)
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
        }
    }
}
