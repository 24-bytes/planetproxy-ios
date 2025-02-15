import SwiftUI

struct VPNConnectButton: View {
    @StateObject private var vpnViewModel = VPNConnectionViewModel()
    let server: VPNServerModel // ✅ Add the selected server

    var body: some View {
        Button(action: {
            Task {
                if vpnViewModel.isConnected {
                    vpnViewModel.disconnectServer()
                } else {
                    await vpnViewModel.connectToServer(server) // ✅ Pass the server argument
                }
            }
        }) {
            Text(vpnViewModel.isConnected ? "Disconnect" : "Connect")
                .foregroundColor(.white)
                .padding()
                .background(vpnViewModel.isConnected ? Color.red : Color.green)
                .cornerRadius(10)
        }
    }
}
