import SwiftUI

struct IPDetailsCardView: View {
    var location: String = "California, USA"
    var countryCode: String? = "us"
    var ipAddress: String = "120.88.42.1"
    var serverCount: Int = 2789

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image("server_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)

                VStack(alignment: .leading) {
                    Text(location)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    Text("VPN IP: \(ipAddress)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                Spacer()

                if let countryCode = countryCode {
                    Image(countryCode)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 16)
                        .cornerRadius(4)
                } else {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
            }

            Text("\(serverCount) servers nearby for fast gaming.")
                .font(.system(size: 14))
                .foregroundColor(.blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.6))
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
        )
        .padding(.horizontal)
    }
}
