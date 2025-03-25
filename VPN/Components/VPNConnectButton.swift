import SwiftUI

struct VPNConnectButton: View {
    @StateObject private var vpnManager = VPNConnectionManager.shared
    @State private var showNoServerAlert = false
    @State private var isAnimatingGlow = false
    @State private var isClicked = false

    let size: CGFloat

    var buttonDisabled: Bool {
        vpnManager.connectionStatus == .connecting || vpnManager.connectionStatus == .disconnecting
    }

    var body: some View {
        ZStack {
            // ✅ Background Glow
            RadialGradient(
                gradient: Gradient(colors: [
                    (vpnManager.connectionStatus == .connected ? Color.green : Color.customPurple).opacity(0.4),
                    Color.black.opacity(0.8)
                ]),
                center: .center,
                startRadius: size * 0.05,
                endRadius: size * 1.2
            )
            .ignoresSafeArea()

            // ✅ Outer Glow Layer
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill((vpnManager.connectionStatus == .connected ? Color.green : Color.customPurple).opacity(0.2))
                .frame(width: size * 1.2, height: size * 1.2)
                .blur(radius: size * 0.2)
                .scaleEffect(isAnimatingGlow ? 1.8 : 1.0)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimatingGlow)

            // ✅ Inner Button (Only Clickable Element)
            RoundedRectangle(cornerRadius: size * 0.15)
                .fill(vpnManager.connectionStatus == .connected ? Color.connectButton : Color.customPurple)
                .frame(width: size, height: size)
                .overlay(
                    Image("thunderbolt")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.4, height: size * 0.4)
                        .foregroundColor(.black)
                )
                .scaleEffect(isClicked ? 0.9 : 1.0)
                .onTapGesture {
                    if !buttonDisabled { handleTap() }
                }
                .disabled(buttonDisabled) // ✅ Disabling interaction when necessary

            // ✅ Outer Border
            RoundedRectangle(cornerRadius: size * 0.15)
                .stroke(Color.white, lineWidth: size * 0.03)
                .frame(width: size * 0.9, height: size * 0.9)
                .shadow(color: (vpnManager.connectionStatus == .connected ? Color.green : Color.customPurple).opacity(0.7), radius: size * 0.15)
        }
        .onAppear {
            isAnimatingGlow = true
        }
        .alert("No Server Selected", isPresented: $showNoServerAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please select a server before connecting to VPN")
        }
    }

    private func handleTap() {
        withAnimation(.easeOut(duration: 0.1)) {
            isClicked = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isClicked = false
            }
        }
        
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
