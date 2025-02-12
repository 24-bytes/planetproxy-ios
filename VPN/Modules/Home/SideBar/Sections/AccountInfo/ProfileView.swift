import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = AccountInfoViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel  // Access authentication state

    var body: some View {
        NavigationView {
            Form {
                personalInfoSection
                accountDetailsSection
                signOutSection
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUserData()
            }
        }
    }

    // ✅ Personal Info Section
    private var personalInfoSection: some View {
        Section(header: Text("Personal Information")) {
            if let user = viewModel.user {
                HStack {
                    profileImage(urlString: user.profileImageURL)
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                ProgressView()
            }
        }
    }

    // ✅ Account Details Section
    private var accountDetailsSection: some View {
        Section(header: Text("Account Details")) {
            if let user = viewModel.user {
                Text("Country: \(user.country)")
            }
        }
    }

    // ✅ Sign Out Section
    private var signOutSection: some View {
        Section {
            Button(action: {
                authViewModel.signOut()
            }) {
                Label("Sign Out", systemImage: "arrow.right.square")
                    .foregroundColor(.red)
            }
        }
    }

    // ✅ Profile Image
    private func profileImage(urlString: String?) -> some View {
        Group {
            if let urlString = urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
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
        .frame(width: 50, height: 50)
        .clipShape(Circle())
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel()) // Pass authViewModel for sign out
}
