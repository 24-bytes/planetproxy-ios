import SwiftUI

struct HomeView: View {
    @StateObject private var vpnViewModel = VPNServersViewModel()
    @StateObject private var vpnManager = VPNConnectionManager.shared
    @State private var showDisconnectPopup: Bool = false
    let navigation: NavigationCoordinator
    let authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Navbar Pinned to Top
                NavBar(navigation: navigation, authViewModel: authViewModel)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.vertical, 10)

                VStack(spacing: 20) {
                    if vpnManager.connectionStatus == .connected {
                        SubscriptionExpiredView()
                            .padding(.top, 15)
                        MetricsView()
                            .padding(.bottom, 30)
                        if let server = vpnManager.selectedServer {
                            TimerView(
                                location: "\(server.region), \(server.countryName)",
                                ipAddress: server.ipAddress,
                                onDisconnect: { showDisconnectPopup = true }
                            )
                            .padding(.bottom, 90)
                        }
                    } else {
                        WelcomeSubscription(navigation: navigation)
                            .padding(.top, 15)
                        // VPN Connect Button
                        VPNConnectButton(size: 145)
                        
                        // Server Details Card
                        ServerDetailsCardView(navigation: navigation)
                            .padding(.bottom, 30)
                    }
                }
                .onAppear {
                    Task {
                        await vpnViewModel.fetchServers()
                        // Set initial server if none selected
                        if vpnManager.selectedServer == nil,
                           let firstServer = vpnViewModel.servers.first?.servers.first {
                            vpnManager.selectServer(firstServer)
                        }
                    }
                }

                Spacer()

                // Footer Pinned to Bottom
                VStack{
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
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            VStack {
                if showDisconnectPopup {
                    DisconnectConfirmationView(
                        isPresented: $showDisconnectPopup,
                        onDisconnectConfirmed: {
                            vpnManager.disconnect()
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
