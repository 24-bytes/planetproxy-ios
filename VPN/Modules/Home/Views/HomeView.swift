import SwiftUI

struct HomeView: View {
    @State private var isConnected: Bool = false
    let navigation: NavigationCoordinator
    @StateObject private var vpnViewModel = VPNServersViewModel()
    @State private var showDisconnectPopup: Bool = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // ✅ Navbar Pinned to Top
                NavBar(navigation: navigation)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.bottom, 10)

                VStack(spacing: 20) {

                    if isConnected {
                        SubscriptionExpiredView()
                            .padding(.top, 30)
                        MetricsView(downloadSpeed: 445.7, uploadSpeed: 765.7)
                            .padding(.bottom, 30)
                        TimerView(                            location: "London, United Kingdom",
                            ipAddress: "120.88.42.1",
                            onDisconnect: { showDisconnectPopup = true } // ✅ Show popup on disconnect
                        )
                            .padding(.bottom, 90)
                    } else {
                        Spacer()
                        WelcomeSubscription()
                        VPNConnectButton(isConnected: $isConnected)
                        if let firstServer = vpnViewModel.servers.first,
                                                   let firstServerDetails = firstServer.servers.first {
                                                    ServerDetailsCardView(
                                                        navigation: navigation,
                                                        location: firstServer.countryName,
                                                        flagUrl: firstServer.countryFlagUrl,
                                                        ipAddress: firstServerDetails.ipAddress,
                                                        serverCount: firstServer.servers.count,
                                                        purpose: firstServerDetails.purpose
                                                    )
                                                    .padding(.bottom, 30)
                                                } else {
                                                    ProgressView("Loading server")
                                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                }
                    }
                }.onAppear {
                    Task {
                        await vpnViewModel.fetchServers()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .animation(.easeInOut(duration: 0.3), value: isConnected)

                Spacer()

                VStack{ // ✅ Footer Pinned to Bottom
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
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            VStack {
                if showDisconnectPopup {
                    DisconnectConfirmationView(
                        isPresented: $showDisconnectPopup,
                        onDisconnectConfirmed: {
                            isConnected = false
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.3))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        } .navigationBarBackButtonHidden(true)
    }
}
