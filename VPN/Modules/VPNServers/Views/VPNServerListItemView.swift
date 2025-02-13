import SwiftUI

struct VPNServerListItemView: View {
    let server: VPNServerModel

    var body: some View {
        HStack {
            // Server Region Name
            Text(server.region)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)

            Spacer()
            
            // Signal Strength Indicator
            Image("signalStrength")
                .resizable()
                .renderingMode(.template) // ✅ Enables color change
                .foregroundColor(getSignalColor(server.signalStrength))
                .frame(width: 20, height: 20) // Adjusted size

            // Latency Information
            Text("\(server.latency) ms")
                .font(.system(size: 14, weight: .ultraLight))
                .foregroundColor(.gray)

            // Connect Button
            Button(action: { connectToServer() }) {
                Text(NSLocalizedString("Connect", comment: "Connect Button"))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.customPurple)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.customPurple, lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color.black) // ✅ Now properly black
        .cornerRadius(10)
        .padding(.horizontal, 6)
    }

    // Determine Signal Strength Icon
    private func getSignalStrengthIcon(_ strength: Int) -> String {
        switch strength {
        case 80...100:
            return "chart.bar.fill" // ✅ Highest strength (Green)
        case 50..<80:
            return "chart.bar.fill" // ✅ Medium strength (Yellow)
        case 0..<50:
            return "chart.bar.fill" // ✅ Low strength (Red)
        default:
            return "chart.bar" // Default to weakest signal
        }
    }

    private func getSignalColor(_ strength: Int) -> Color {
        switch strength {
        case 80...100:
            return .green // ✅ Strong signal
        case 50..<80:
            return .yellow // ✅ Medium signal
        case 0..<50:
            return .red // ✅ Weak signal
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
