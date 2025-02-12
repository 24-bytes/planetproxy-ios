
import SwiftUI

struct VPNServerListItemView: View {
    let server: VPNServerModel

    var body: some View {
        HStack {
            // Signal Strength Indicator
            Image(systemName: getSignalStrengthIcon(server.signalStrength))
                .foregroundColor(getSignalColor(server.signalStrength))
                .frame(width: 20, height: 20)

            // Server Region Name
            Text(server.region)
                .font(.system(size: 16))
                .foregroundColor(.white)

            Spacer()

            // Latency Information
            Text("\(server.latency) ms")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            // Connect Button
            Button(action: { connectToServer() }) {
                Text("Connect")
                    .font(.system(size: 14))
                    .foregroundColor(.purple)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.purple, lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
        .padding(.horizontal, 8)
    }

    // Determine Signal Strength Icon
    private func getSignalStrengthIcon(_ strength: Int) -> String {
        switch strength {
        case 80...100:
            return "wifi"
        case 50..<80:
            return "wifi.exclamationmark"
        case 0..<50:
            return "wifi.slash"
        default:
            return "wifi.slash"
        }
    }

    // Determine Signal Strength Color
    private func getSignalColor(_ strength: Int) -> Color {
        switch strength {
        case 80...100:
            return .green
        case 50..<80:
            return .orange
        case 0..<50:
            return .red
        default:
            return .gray
        }
    }

    // Mock Function to Handle Connection
    private func connectToServer() {
        print("Connecting to \(server.serverName) at \(server.ipAddress)...")
        // TODO: Implement VPN connection logic
    }
}

#Preview {
    VPNServerListItemView(
        server: VPNServerModel(
            id: 10,
            serverName: "HOSTINGER_INDIA_2",
            countryName: "India",
            purpose: "game",
            countryFlagUrl: "https://flagcdn.com/w160/in.png",
            stealth: "95",
            latency: 20,
            region: "Mumbai",
            signalStrength: 100,
            serversCount: 253,
            isPremium: false,
            isDefault: false,
            isActive: true,
            countryId: 1,
            ipAddress: "147.93.110.102"
        )
    )
}
