import SwiftUI

struct VPNServerListItemView: View {
    let server: VPNServerModel
    let navigation: NavigationCoordinator
    @StateObject private var vpnManager = VPNConnectionManager.shared
    @State private var displayedLatency: Int
    @State private var connectionError: String?

    init(server: VPNServerModel, navigation: NavigationCoordinator) {
        self.server = server
        self.navigation = navigation
        _displayedLatency = State(initialValue: server.latency)
    }

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
                .renderingMode(.template)
                .foregroundColor(getSignalColor(server.signalStrength))
                .frame(width: 20, height: 20)

            // Latency Information
            Text("\(displayedLatency) ms")
                .font(.system(size: 14, weight: .ultraLight))
                .foregroundColor(.gray)
                .animation(.easeInOut(duration: 0.2), value: displayedLatency)

            // Connect/Selected Status
            if vpnManager.selectedServer?.id == server.id {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.customPurple)
                    .font(.system(size: 20))
            } else {
                Button(action: { selectServer(); navigation.navigateToHome() }) {
                    Text("Connect")
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
        }
        .onAppear {
            startLatencyUpdates()
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .padding(.horizontal, 6)
    }

    private func startLatencyUpdates() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            let newLatency = (server.latency - 5...server.latency + 5).randomElement() ?? server.latency
            displayedLatency = max(1, newLatency)
        }
    }

    private func getSignalColor(_ strength: Int) -> Color {
        switch strength {
        case 80...100:
            return .green
        case 50..<80:
            return .yellow
        case 0..<50:
            return .red
        default:
            return .gray
        }
    }

    private func selectServer() {
        vpnManager.selectServer(server)
    }
}
