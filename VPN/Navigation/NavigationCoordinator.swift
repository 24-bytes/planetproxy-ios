//
//  NavigationCoordinator.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var path: [Route] = []
    
    func navigate(to route: Route) {
        path.append(route)
    }

    func goBack() {
        path.removeLast()
    }

    func reset() {
        path.removeAll()
    }
}
