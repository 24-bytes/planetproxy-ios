import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Toggle("Start on Boot", isOn: $viewModel.startOnBoot)
            Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
            Toggle("Dark Mode", isOn: $viewModel.darkModeEnabled)
        }
        .onAppear { viewModel.loadSettings() }
    }
}
