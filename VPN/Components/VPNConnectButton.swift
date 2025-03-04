import SwiftUI

struct VPNConnectButton: View {
    @StateObject private var vpnManager = VPNConnectionManager.shared
    @State private var showNoServerAlert = false
    
    var body: some View {
        ZStack {
            // ✅ Background Glow Gradient
            RadialGradient(
                gradient: Gradient(colors: [
                    (vpnManager.connectionStatus == .connected ? Color.green : Color.customPurple).opacity(0.4),
                    Color.black.opacity(0.8)
                ]),
                center: .center,
                startRadius: 10,
                endRadius: 200 // ✅ Soft spread for glow
            )
            .ignoresSafeArea()

            // ✅ Outer Glow Layer
            RoundedRectangle(cornerRadius: 45)
                .fill((vpnManager.connectionStatus == .connected ? Color.green : Color.customPurple).opacity(0.2))
                .frame(width: 220, height: 220)
                .blur(radius: 40) // ✅ Smooth Glow Effect
            
            // ✅ Inner Green Button
            RoundedRectangle(cornerRadius: 35)
                .fill(vpnManager.connectionStatus == .connected ? Color.connectButton : Color.customPurple) // ✅ Light green exact shade
                .frame(width: 150, height: 150)
                .overlay(
                    Image("thunderbolt") // ✅ Thunderbolt Icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black) // ✅ Icon in center
                )
            
            // ✅ Outer Border
            RoundedRectangle(cornerRadius: 35)
                .stroke(Color.white, lineWidth: 4)
                .frame(width: 140, height: 140)
                .shadow(color: (vpnManager.connectionStatus == .connected ? Color.green : Color.customPurple).opacity(0.7), radius: 20) // ✅ Soft Shadow Effect
        }
        .onTapGesture {
            handleTap()
        }
        .alert("No Server Selected", isPresented: $showNoServerAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please select a server before connecting to VPN")
        }
    }
    
    private func handleTap() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if vpnManager.connectionStatus == .connected {
                vpnManager.disconnect()
            } else {
                if vpnManager.selectedServer == nil {
                    showNoServerAlert = true
                } else {
                    vpnManager.connectToSelectedServer()
                }
            }
        }
    }
}

// ✅ Live Preview
struct VPNConnectButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VPNConnectButton()
        }
    }
}
