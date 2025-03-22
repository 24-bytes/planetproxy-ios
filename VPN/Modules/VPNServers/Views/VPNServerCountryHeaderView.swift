import SwiftUI

struct VPNServerCountryHeaderView: View {
    let country: VPNServerCountryModel
    let navigation: NavigationCoordinator
    let searchQuery: String // Pass searchQuery to determine expanded state
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    AsyncImage(url: URL(string: country.countryFlagUrl)) { image in
                        image.resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    } placeholder: {
                        Image(systemName: "globe")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 40, height: 24)

                    Text(country.countryName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)

                    Spacer()

                    if country.isPremium {
                        VPNServerPremiumTagView()
                    }

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .frame(width: 24, height: 24)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .frame(height: 60)
                .padding(.horizontal)
                .cornerRadius(12)
            }

            if isExpanded {
                VStack(spacing: 5) {
                    ForEach(country.servers) { server in
                        VPNServerListItemView(server: server, navigation: navigation)
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 8)
                    }
                }
                .padding(.bottom, 10)
                .cornerRadius(12)
                .padding(.horizontal, 3)
            }
        }
        .background(Color.cardBg)
        .cornerRadius(12)
        .padding(.horizontal)
        .onChange(of: searchQuery) { newValue in
                    isExpanded = !newValue.isEmpty // ✅ Expands when searching, collapses when empty
                }
    }
}
