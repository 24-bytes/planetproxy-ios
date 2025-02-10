//
//  NavigationCoordinator.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import SwiftUI

class NavigationCoordinator: ObservableObject {
    static let shared = NavigationCoordinator()
    @Published var path = NavigationPath()
    
    func navigateToHome() {
        DispatchQueue.main.async {
            self.path.removeLast(self.path.count) // Clear previous navigation stack
            self.path.append(Route.home)
        }
    }
    
    func navigateToLogin() {
            DispatchQueue.main.async {
                self.path.removeLast(self.path.count) // Clear previous navigation stack
                self.path.append(Route.login) // ✅ Redirect to login
            }
        }
}


