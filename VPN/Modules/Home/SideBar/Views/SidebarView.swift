import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var sidebarViewModel: SidebarViewModel // ✅ Now using environment object
    @EnvironmentObject var authViewModel: AuthViewModel // ✅ Injected AuthViewModel
    @EnvironmentObject var navigation: NavigationCoordinator

    var body: some View {
        ZStack {
            if sidebarViewModel.isSidebarOpen {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { sidebarViewModel.isSidebarOpen = false }
            }

            HStack {
                VStack(alignment: .leading, spacing: 16) { // ✅ Reduced spacing from 24 to 16
                    // Close Button (Moved Down)
                    Button(action: { sidebarViewModel.isSidebarOpen = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.top, 40) // ✅ Move close button down
                            .padding(.leading, 16) // ✅ Align properly
                    }

                    // Welcome Text
                    Text("Welcome back,\n**Christopher Flem**")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16) // ✅ Added padding for alignment

                    // Sidebar Menu Items
                    ForEach(sidebarViewModel.menuItems) { item in
                        SidebarItemView(item: item, viewModel: sidebarViewModel, navigation: navigation)
                            .padding(.leading, 16) // ✅ Align menu items properly
                    }

                    Spacer()

                    // Footer
                    SidebarFooterView()
                        .padding(.leading, 16) // ✅ Align footer properly
                        .padding(.bottom, 20) // ✅ Prevents it from sticking to the bottom
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
