import SwiftUI

struct SecurityView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isTwoFactorEnabled = false
    
    var body: some View {
        Form {
            Section(header: Text("Change Password")) {
                SecureField("Current Password", text: $currentPassword)
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmPassword)
                
                Button("Update Password") {
                    // TODO: Implement password update
                }
                .disabled(newPassword.isEmpty || newPassword != confirmPassword)
            }
            
            Section(header: Text("Two-Factor Authentication")) {
                Toggle("Enable 2FA", isOn: $isTwoFactorEnabled)
                
                if isTwoFactorEnabled {
                    Text("Scan QR code to set up 2FA")
                    // TODO: Add QR code image for 2FA setup
                }
            }
            
            Section(header: Text("Active Sessions")) {
                // TODO: Implement active sessions list
                Button("Sign Out All Devices") {
                    // TODO: Implement sign out
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Security")
    }
}

#Preview {
    SecurityView()
}
