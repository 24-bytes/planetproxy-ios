import SwiftUI

struct HomeView: View {
    @State private var isConnected: Bool = false
    @State private var showSubscriptionBanner: Bool = false
    let navigation: NavigationCoordinator

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                NavBar()
                Spacer().frame(height: 30)

                // VPN Metrics Section
                if isConnected {
                    MetricsView(downloadSpeed: 445.7, uploadSpeed: 765.7)
                        .frame(height: 80)
                    
                    Spacer().frame(height: 15)
                    
                    TimerView(
                        navigation: navigation,
                        location: "London, United Kingdom",
                        ipAddress: "120.88.42.1"
                    )
                        .frame(height: 80)
                } else {
                    Spacer().frame(height: 80)
                }
                
                // VPN Connect Button
                VPNConnectButton(isConnected: $isConnected, navigation: navigation)


                // IP Details
                ServerDetailsCardView(
                    navigation: navigation,
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
