import SwiftUI

struct ServerDetailsCardView: View {
    let navigation: NavigationCoordinator
    var location: String
    var flagUrl: String
    var ipAddress: String
    var serverCount: Int
    var purpose: String // Determines the server type icon

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                            Circle()
                                .fill(Color(hex: "#6A5ACD")) // Soft purple background
                                .frame(width: 50, height: 50)

                            Image(systemName: getServerIcon(for: purpose))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.white) // Icon in white for contrast
                        }
                        .padding(.leading, 10) // ✅ Adjusting left spacing
            
            // ✅ Middle Section: Server Details
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    Text(location)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    // ✅ Circular Country Flag
                    AsyncImage(url: URL(string: flagUrl)) { image in
                        image.resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    } placeholder: {
                        Image(systemName: "globe")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 24, height: 24) // Smaller for accuracy
                }

                Text("VPN IP: \(ipAddress)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text("\(serverCount) servers nearby for fast gaming.")
                    .font(.system(size: 14))
                    .foregroundColor(Color.customPurple)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#14131A")) // Dark background
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
        )
        .padding(.horizontal)
    }

    // ✅ Determines the system image based on server purpose
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
