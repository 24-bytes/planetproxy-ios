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
                   
                    VStack(alignment: .leading, spacing: 16) {
                        // Close Button (Moved Down)
                        Button(action: { sidebarViewModel.isSidebarOpen = false }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding(.top, 60)
                        }
                        
                        // Welcome Text
                        let userName = userInfoModel.accountInfo?.displayName ?? ""
                        Text(userName.isEmpty ? "Please log in :)" : "Welcome back \(userName)")
                            .font(.title3)
                            .foregroundColor(.white)
                    }.padding(.leading)
                    // Sidebar Menu Items
                    ForEach(sidebarViewModel.menuItems) { item in
                        SidebarItemView(
                            item: item, viewModel: sidebarViewModel,
                            navigation: navigation
                        )
                    }

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
            userInfoModel.fetchAccountData()
        }.navigationBarBackButtonHidden(true)
    }
}
