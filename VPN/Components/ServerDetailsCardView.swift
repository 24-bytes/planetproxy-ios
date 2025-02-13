import SwiftUI

struct ServerDetailsCardView: View {
    let navigation: NavigationCoordinator

    var location: String = "California, USA"
    var countryCode: String? = "us"
    var ipAddress: String = "120.88.42.1"
    var serverCount: Int = 2789

    var body: some View {
        HStack(spacing: 12) { // ✅ Ensures proper spacing in horizontal layout
            // ✅ Left Section: Icon & Server Details
            HStack(spacing: 10) {
                Image("server_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(location)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        if let countryCode = countryCode {
                            Image(countryCode)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 16)
                                .cornerRadius(4)
                        } else {
                            Image(systemName: "flag.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    }

                    Text("VPN IP: \(ipAddress)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Text("\(serverCount) servers nearby for fast gaming.")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
            }

            Spacer()

            // ✅ Right Section: Arrow Button
            Button(action: { navigation.navigateToServers() }) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.2)) // ✅ Grey background
                    .clipShape(Circle()) // ✅ Circular shape
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBg)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
        )
        .padding(.horizontal)
    }
}
