import SwiftUI

struct SettingsView: View {
    @State private var startOnBoot = false
    @State private var notifications = true
    @State private var isDarkMode = true
    @State private var selectedLanguage = "English - United States"
    
    var body: some View {
        Form {
            Section(header: Text("General")) {
                Toggle("Start on Boot", isOn: $startOnBoot)
                Toggle("Notifications", isOn: $notifications)
                Toggle("Dark Mode", isOn: $isDarkMode)
                
                // Language picker
                NavigationLink(destination: Text("Language Selection")) {
                    HStack {
                        Text("Language")
                        Spacer()
                        Text(selectedLanguage)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}
