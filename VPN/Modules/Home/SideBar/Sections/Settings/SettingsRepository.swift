//
//  SettingsRepository.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 14/02/25.
//

import Foundation

class SettingsRepository {
    private let userDefaults = UserDefaults.standard

    func fetchSettings() -> [SettingOption] {
        return [
            SettingOption(title: "Start on Boot", description: "Enable VPN on system boot.", category: .general, isToggleable: true, isOn: userDefaults.bool(forKey: "startOnBoot")),
            SettingOption(title: "VPN Acceleration", description: "Enhance VPN performance up to 400%.", category: .general, isToggleable: true, isOn: userDefaults.bool(forKey: "vpnAcceleration")),
            SettingOption(title: "NetShield", description: "Block ads, trackers, and malware.", category: .security, isToggleable: true, isOn: userDefaults.bool(forKey: "netShield")),
            SettingOption(title: "Kill Switch", description: "Disable internet if VPN disconnects.", category: .security, isToggleable: true, isOn: userDefaults.bool(forKey: "killSwitch"))
        ]
    }

    func saveSetting(_ setting: SettingOption) {
        userDefaults.set(setting.isOn, forKey: setting.title.replacingOccurrences(of: " ", with: ""))
    }

    func saveLanguage(_ language: String) {
        userDefaults.set(language, forKey: "selectedLanguage")
    }

    func getSelectedLanguage() -> String {
        return userDefaults.string(forKey: "selectedLanguage") ?? "English (Default)"
    }
}

