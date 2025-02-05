import SwiftUI

struct VPNConnectButton: View {
    @Binding var isConnected: Bool

    var body: some View {
        VStack(spacing: 10) {
            Text(isConnected ? "Your connection is secure" : "Your connection is unsecure")
                .foregroundColor(.white)
                .font(.system(size: 14))

            Button(action: {
                withAnimation {
                    isConnected.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(isConnected ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                        .frame(width: 160, height: 160)
                        .shadow(color: isConnected ? .green : .red, radius: 15)

                    RoundedRectangle(cornerRadius: 25)
                        .fill(isConnected ? Color.green : Color.white)
                        .frame(width: 130, height: 130)
                        .overlay(
                            Image(isConnected ? "vpn_on_icon" : "vpn_off_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        )
                        .shadow(color: isConnected ? .green : .red, radius: 10)
                }
            }

            Text(isConnected ? "Disconnect" : "Connect now")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
        }
        .padding(.vertical)
    }
}
