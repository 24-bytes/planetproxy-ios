import SwiftUI

struct VPNServersView: View {
    @StateObject private var viewModel = VPNServersViewModel()
    let navigation: NavigationCoordinator
    let tabs = ["Default", "Browsing", "Gaming"]

    var body: some View {
        VStack {
            ToolbarView(title: "Servers")
            // Tab Selector
            VPNServerTabView(selectedTab: $viewModel.selectedTab, tabs: tabs)

            // Search Bar with Extra Vertical Spacing
            VPNServerSearchView(searchQuery: $viewModel.searchQuery)
                .padding(.bottom, 12) // ✅ Adds vertical spacing below search bar

            // Full-Screen Fixed Content
            ZStack {
                // Background for Full-Screen Consistency
                VStack {
                    Spacer() // ✅ Prevents shifting by keeping space
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Actual Content
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    ScrollView {
                        ForEach(viewModel.filteredServers()) { country in
                            VPNServerCountryHeaderView(country: country)
                                .padding(.bottom, 6)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // ✅ Ensures full-height layout
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            Task {
                await viewModel.fetchServers()
            }
        }
            .navigationBarBackButtonHidden(true)
    }
}
