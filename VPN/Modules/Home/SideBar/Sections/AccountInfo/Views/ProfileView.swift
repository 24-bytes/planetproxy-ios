import SwiftUI

struct ProfileView: View {
    var accountInfo: AccountInfoModel?
    var authViewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ✅ Profile Picture Section
            if let user = accountInfo {
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedStringKey("your_photo"))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    profileImage(urlString: user.profilePictureURL)
                }
            }
            // ✅ Input Fields (Name, Email, Country, Timezone)
            inputField(
                title: "Name*",
                text: accountInfo?.displayName ?? "Loading..."
            )
            inputField(title: "Email*", text: accountInfo?.email ?? "Loading...", isEmail: true)
            inputField(title: "Subscription Status", text: "Active")
            Spacer()
            logoutButton
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    // ✅ Custom Input Field
    private func inputField(title: String, text: String, isEmail: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)

            TextField("", text: .constant(text))
                .padding()
                .background(Color.fieldBg)
                .cornerRadius(8)
                .foregroundColor(isEmail ? .gray : .white)
                .disabled(true) // ✅ Non-editable fields
        }
    }


        // ✅ Timezone Field
        private func timezoneField() -> some View {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let currentTime = timeFormatter.string(from: Date())

            let timezoneName = TimeZone.current.identifier
            let timezoneOffset = TimeZone.current.secondsFromGMT() / 3600
            let formattedOffset = String(format: "UTC%+d:00", timezoneOffset)

            return VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStringKey("time"))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)

                    Text("\(currentTime) | \(timezoneName) (\(formattedOffset))")
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.fieldBg)
                .cornerRadius(8)
            }
        }

    // ✅ Profile Image (Rounded, Scaled, White Border)
    private func profileImage(urlString: String?) -> some View {
        Group {
            if let urlString = urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 90, height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 1)) // ✅ White border
    }

    private var logoutButton: some View {
        Button(action: {
            authViewModel.signOut()
            AnalyticsManager.shared.trackEvent(EventName.TAP.LOGOUT)
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.forward") // ✅ Matches provided logout icon
                    .foregroundColor(.gray)
                    .font(.system(size: 24, weight: .bold))

                Text(LocalizedStringKey("logout"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
