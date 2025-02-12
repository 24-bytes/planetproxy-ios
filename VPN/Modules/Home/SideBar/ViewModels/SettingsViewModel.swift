import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var startOnBoot = false
    @Published var notificationsEnabled = true
    @Published var darkModeEnabled = false

    func loadSettings() {
        startOnBoot = UserDefaults.standard.bool(forKey: "startOnBoot")
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    }

    func saveSettings() {
        UserDefaults.standard.set(startOnBoot, forKey: "startOnBoot")
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(darkModeEnabled, forKey: "darkModeEnabled")
    }
}
