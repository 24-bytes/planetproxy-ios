import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var sidebarViewModel: SidebarViewModel 
    let userInfoModel: AccountInfoViewModel
    let navigation: NavigationCoordinator

    var body: some View {
        ZStack {
            if sidebarViewModel.isSidebarOpen {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { sidebarViewModel.isSidebarOpen = false }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                   
                    VStack(alignment: .leading, spacing: 12) {
                        // Close Button (Moved Down)
                        Button(action: { sidebarViewModel.isSidebarOpen = false }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding(.top, 60)
                        }
                        
                        // Welcome Text
                        let userName = userInfoModel.accountInfo?.displayName ?? ""
                        Text(userName.isEmpty ? NSLocalizedString("please_log_in", comment: "Prompt to log in") : String(format: NSLocalizedString("welcome_back", comment: "Welcome message"), userName))
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        // Sidebar Menu Items
                        ForEach(sidebarViewModel.menuItems) { item in
                            SidebarItemView(
                                item: item, viewModel: sidebarViewModel,
                                navigation: navigation
                            )
                        }
                    }.padding(.leading, 24)
                    Spacer()

                    // Footer
                    SidebarFooterView()
                        .padding(.leading, 16)
                        .padding(.bottom, 20)
                }
                .frame(width: 330)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)

                Spacer()
            }
            .offset(x: sidebarViewModel.isSidebarOpen ? 0 : -360)
            .animation(.easeInOut(duration: 0.3))
        }.onAppear {
            AnalyticsManager.shared.trackEvent(EventName.VIEW.DASHBOARD_SCREEN)
            userInfoModel.fetchAccountData()
        }.navigationBarBackButtonHidden(true)
    }
}
