
import SwiftUI

struct VPNServersView: View {
    @StateObject private var viewModel = VPNServersViewModel()

    var body: some View {
        VStack {
            HStack {
                Button(action: { /* Navigate Back */ }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                }

                Text("Servers")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()

            VPNServerTabView(selectedTab: $viewModel.selectedTab)
            VPNServerSearchView(searchQuery: $viewModel.searchQuery)

            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    ForEach(viewModel.filteredServers()) { country in
                        VPNServerCountryHeaderView(country: country)
                    }
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            Task {
                await viewModel.fetchServers()
            }
        }
    }
}
