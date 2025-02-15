import SwiftUI

struct VPNServerListItemView: View {
    let server: VPNServerModel
    @State private var displayedLatency: Int

    init(server: VPNServerModel) {
        self.server = server
        _displayedLatency = State(initialValue: server.latency) // ✅ Set initial latency
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
                .renderingMode(.template) // ✅ Enables color change
                .foregroundColor(getSignalColor(server.signalStrength))
                .frame(width: 20, height: 20) // Adjusted size

            // Latency Information
            Text("\(displayedLatency) ms")
                    .font(.system(size: 14, weight: .ultraLight))
                    .foregroundColor(.gray)
                    .animation(.easeInOut(duration: 0.2), value: displayedLatency)

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
        }.onAppear {
            startLatencyUpdates()
        }
        .padding()
        .background(Color.black) // ✅ Now properly black
        .cornerRadius(10)
        .padding(.horizontal, 6)
    }
    
    private func startLatencyUpdates() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            let newLatency = (server.latency - 5...server.latency + 5).randomElement() ?? server.latency
            displayedLatency = max(1, newLatency) // ✅ Prevent negative latency
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
        Task {
            do {
                let tunnel = try await VPNConnectionManager.shared.fetchAndDecodePeer(for: server.countryId)
                try VPNConnectionManager.shared.connectToVPN()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
