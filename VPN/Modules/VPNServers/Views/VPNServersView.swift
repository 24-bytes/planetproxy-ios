import SwiftUI

struct VPNServersView: View {
    @StateObject private var viewModel = VPNServersViewModel()
    let navigation: NavigationCoordinator
    let tabs = ["Default", "Browsing", "Gaming"]

    var body: some View {
        VStack {
            ToolbarView(title: String(localized: "servers"), navigation: navigation)
                .safeAreaInset(edge: .top) {
                    Spacer().frame(height: 20)
                }

            VPNServerTabView(selectedTab: $viewModel.selectedTab, tabs: tabs)
                .padding(.bottom, 5)

            VPNServerSearchView(searchQuery: $viewModel.searchQuery)
                .padding(.bottom, 10)

            GeometryReader { geometry in
                ZStack {
                    VStack {
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 8) {
                                ForEach(viewModel.filteredServers()) { country in
                                    VPNServerCountryHeaderView(
                                        country: country,
                                        navigation: navigation,
                                        searchQuery: viewModel.searchQuery
                                    )
                                    .padding(.bottom, 6)
                                }
                            }
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        }
                        .frame(maxHeight: .infinity)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            AnalyticsManager.shared.trackEvent(EventName.VIEW.SERVERS_SCREEN)
            Task {
                await viewModel.fetchServers()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // ✅ Prevents pushing view up when keyboard appears
        .navigationBarBackButtonHidden(true)
    }
}
