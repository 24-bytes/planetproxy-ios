//
//  SettingOption.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 14/02/25.
//

import Foundation

enum SettingCategory: String, CaseIterable {
    case general = "General"
    case security = "Security"
    case language = "Language"
}

struct SettingOption: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: SettingCategory
    let isToggleable: Bool
    var isOn: Bool = false
}
