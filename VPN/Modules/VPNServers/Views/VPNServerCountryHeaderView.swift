import SwiftUI

struct VPNServerCountryHeaderView: View {
    let country: VPNServerCountryModel
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: { isExpanded.toggle() }) { // ✅ Entire row is clickable
                HStack {
                    // ✅ Circular Country Flag
                    AsyncImage(url: URL(string: country.countryFlagUrl)) { image in
                        image.resizable()
                            .clipShape(Circle()) // Make it circular
                            .overlay(Circle().stroke(Color.white, lineWidth: 1)) // Add white border
                    } placeholder: {
                        Image(systemName: "globe")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 40, height: 24) // Scaled properly

                    // Country Name
                    Text(country.countryName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)

                    Spacer()

                    // ✅ Premium Badge Positioned to Right
                    if country.isPremium {
                        VPNServerPremiumTagView()
                    }

                    // ✅ Expand/Collapse Button with Ring
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .frame(width: 24, height: 24) // ✅ Ensures proper circular size
                        .background(Color.gray.opacity(0.2)) // ✅ Grey background
                        .clipShape(Circle()) // ✅ Makes it a perfect circle
                }
                .frame(height: 60)
                .padding(.horizontal)
                .cornerRadius(12)
            }

            // Expanded Server List
            if isExpanded {
                VStack(spacing: 5) {
                    ForEach(country.servers) { server in
                        VPNServerListItemView(server: server)
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
    }
}
