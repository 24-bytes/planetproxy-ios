import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var sidebarViewModel: SidebarViewModel 
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigation: NavigationCoordinator

    var body: some View {
        ZStack {
            if sidebarViewModel.isSidebarOpen {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { sidebarViewModel.isSidebarOpen = false }
            }

            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    // Close Button (Moved Down)
                    Button(action: { sidebarViewModel.isSidebarOpen = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.top, 40)
                            .padding(.leading, 16)
                    }

                    // Welcome Text
                    Text("Welcome back,\n**Christopher Flem**")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)

                    // Sidebar Menu Items
                    ForEach(sidebarViewModel.menuItems) { item in
                        SidebarItemView(
                            item: item, viewModel: sidebarViewModel,
                            navigation: navigation
                        )
                        .padding(.leading, 16)
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
        }
    }
}
