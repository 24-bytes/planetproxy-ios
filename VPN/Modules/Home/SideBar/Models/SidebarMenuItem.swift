//
//  SidebarMenuItem.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 11/02/25.
//

import SwiftUI

enum SidebarDestination {
    case accountInfo
    case servers
    case settings
    case faq
    case support
    case rateUs
    case privacyPolicy
}

struct SidebarMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: SidebarDestination
}
