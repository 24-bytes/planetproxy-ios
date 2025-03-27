import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var isLanguagePickerPresented = false
    let navigation: NavigationCoordinator

    var body: some View {
        VStack(spacing: 16) {
            // ✅ Header Section
            ToolbarView(title: "Settings", navigation: navigation)
              

            // ✅ Settings List
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // ✅ Language Selection Section
                    Text("Language Selection")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)

                    LanguageSelectionView(selectedLanguage: $viewModel.selectedLanguage, isPresented: $isLanguagePickerPresented)

                    // ✅ Toggle Options
                    VStack(spacing: 16) {
                        ForEach(viewModel.settings) { setting in
                            SettingRowView(setting: setting) {
                                viewModel.toggleSetting(setting)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
                    AnalyticsManager.shared.trackEvent(EventName.VIEW.SETTINGS_SCREEN)
                }
        .navigationBarBackButtonHidden(true)
    }
}
    
struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String
    @Binding var isPresented: Bool

    var body: some View {
        Button(action: { isPresented = true }) {
            HStack {
                Text(selectedLanguage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2)) // ✅ Lighter background
            .cornerRadius(8)
        }
        .sheet(isPresented: $isPresented) {
            LanguagePicker(selectedLanguage: $selectedLanguage)
                .frame(maxWidth: .infinity)
            
        }
    }
}


// ✅ Setting Row with Proper Styling
struct SettingRowView: View {
    let setting: SettingOption
    let action: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(setting.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Text(setting.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            if setting.isToggleable {
                Toggle("", isOn: Binding(
                    get: { setting.isOn },
                    set: { _ in action() }
                ))
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .purple)) // ✅ Purple switch
            }
        }
        .padding()
        .background(Color.black) // ✅ Correct background
    }
}
