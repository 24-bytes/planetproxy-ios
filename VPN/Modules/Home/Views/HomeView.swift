import SwiftUI

struct HomeView: View {
    @State private var isConnected: Bool = false
    @State private var showSubscriptionBanner: Bool = true
    let navigation: NavigationCoordinator

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                NavBar()
                Spacer().frame(height: 30)
                Group {
                    if showSubscriptionBanner {
                        SubscriptionExpiredView()
                            .frame(height: 60)
                    } else {
                        Color.clear.frame(height: 60)
                    }
                }

                // VPN Metrics Section
                if isConnected {
                    MetricsView(downloadSpeed: 445.7, uploadSpeed: 765.7)
                        .frame(height: 80)
                } else {
                    Spacer().frame(height: 80)
                }

                // VPN Connect Button
                VPNConnectButton(isConnected: $isConnected, navigation: navigation) // ✅ Pass explicitly


                // IP Details
                IPDetailsCardView(
                    location: "California, USA",
                    countryCode: "us",
                    ipAddress: "120.88.42.1",
                    serverCount: 2789
                )

                Spacer()

                // Footer Security Notice
                Text("Your data is safe with ")
                    .foregroundColor(.white)
                    .font(.system(size: 12)) +
                Text("AES-256 bit encryption.")
                    .foregroundColor(.purple)
                    .font(.system(size: 12, weight: .medium)) +
                Text(" We don’t track or sell personal information.")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
            .padding(.vertical)
        }
    }
}
