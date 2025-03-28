import Foundation

class SettingsRepository {
    private let userDefaults = UserDefaults.standard

    func fetchSettings() -> [SettingOption] {
        return [
            SettingOption(
                title: NSLocalizedString("start_on_boot", comment: "Start on Boot"),
                description: NSLocalizedString("start_on_boot_desc", comment: "Enable VPN on system boot."),
                category: .general,
                isToggleable: true,
                isOn: userDefaults.object(forKey: "startOnBoot") == nil ? true : userDefaults.bool(forKey: "startOnBoot")
            ),
            SettingOption(
                title: NSLocalizedString("vpn_acceleration", comment: "VPN Acceleration"),
                description: NSLocalizedString("vpn_acceleration_desc", comment: "Enhance VPN performance up to 400%."),
                category: .general,
                isToggleable: true,
                isOn: userDefaults.object(forKey: "vpnAcceleration") == nil ? true : userDefaults.bool(forKey: "vpnAcceleration")
            ),
            SettingOption(
                title: NSLocalizedString("netshield", comment: "NetShield"),
                description: NSLocalizedString("netshield_desc", comment: "Block ads, trackers, and malware."),
                category: .security,
                isToggleable: true,
                isOn: userDefaults.object(forKey: "netShield") == nil ? true : userDefaults.bool(forKey: "netShield")
            ),
            SettingOption(
                title: NSLocalizedString("kill_switch", comment: "Kill Switch"),
                description: NSLocalizedString("kill_switch_desc", comment: "Disable internet if VPN disconnects."),
                category: .security,
                isToggleable: true,
                isOn: userDefaults.object(forKey: "killSwitch") == nil ? true : userDefaults.bool(forKey: "killSwitch")
            )
        ]
    }

    func saveSetting(_ setting: SettingOption) {
        userDefaults.set(setting.isOn, forKey: setting.title.replacingOccurrences(of: " ", with: ""))
    }

    func saveLanguage(_ language: String) {
        userDefaults.set(language, forKey: "selectedLanguage")
    }

    func getSelectedLanguage() -> String {
        return userDefaults.string(forKey: "selectedLanguage") ?? NSLocalizedString("default_language", comment: "English (Default)")
    }
}
