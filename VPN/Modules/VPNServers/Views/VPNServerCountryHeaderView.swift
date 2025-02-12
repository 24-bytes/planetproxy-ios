
import SwiftUI

struct VPNServerCountryHeaderView: View {
    let country: VPNServerCountryModel
    @State private var isExpanded = false

    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: country.countryFlagUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "globe")
                }
                .frame(width: 30, height: 20)

                Text(country.countryName)
                    .font(.headline)
                    .foregroundColor(.white)

                if country.isPremium {
                    VPNServerPremiumTagView()
                }

                Spacer()

                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
            }
            .padding()

            if isExpanded {
                ForEach(country.servers) { server in
                    VPNServerListItemView(server: server)
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}
