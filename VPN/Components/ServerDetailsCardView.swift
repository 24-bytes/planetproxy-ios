import SwiftUI

struct ServerDetailsCardView: View {
    let navigation: NavigationCoordinator
    @StateObject private var vpnManager = VPNConnectionManager.shared
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Button(action: {
                    navigation.navigateToServers()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                        )
                }
                .frame(width: 44, height: 44)
            }
            
            if let server = vpnManager.selectedServer {
                // Server Icon
                ZStack {
                    Circle()
                        .fill(Color(hex: "#6A5ACD"))
                        .frame(width: 50, height: 50)

                    Image(systemName: getServerIcon(for: server.purpose))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                }
                .padding(.leading, 10)
                
                // Server Details
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 12) {
                        Text(server.countryName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        AsyncImage(url: URL(string: server.countryFlagUrl)) { image in
                            image.resizable()
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        } placeholder: {
                            Image(systemName: "globe")
                                .foregroundColor(.gray)
                        }
                        .frame(width: 24, height: 24)
                    }

                    Text("VPN IP: \(server.ipAddress)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            } else {
                ProgressView("Loading server")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#14131A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
        )
        .padding(.horizontal)
    }
    
    private func getServerIcon(for purpose: String) -> String {
        switch purpose.lowercased() {
        case "game":
            return "gamecontroller.fill"
        case "safe-browsing":
            return "shield.lefthalf.filled"
        case "streaming":
            return "play.tv.fill"
        default:
            return "network"
        }
    }
}
