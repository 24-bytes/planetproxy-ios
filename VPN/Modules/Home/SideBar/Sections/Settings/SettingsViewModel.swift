import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var settings: [SettingOption] = []
    @Published var selectedLanguage: String

    private let repository = SettingsRepository()

    init() {
        selectedLanguage = repository.getSelectedLanguage()
        loadSettings()
    }

    func loadSettings() {
        settings = repository.fetchSettings()
    }

    func toggleSetting(_ setting: SettingOption) {
        if let index = settings.firstIndex(where: { $0.id == setting.id }) {
            settings[index].isOn.toggle()
            repository.saveSetting(settings[index])
        }
    }

    func changeLanguage(to language: String) {
        selectedLanguage = language
        repository.saveLanguage(language)
        loadSettings()
    }
}
