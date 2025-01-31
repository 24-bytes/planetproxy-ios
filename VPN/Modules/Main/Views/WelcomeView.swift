
import SwiftUI
import FirebaseAuth

struct WelcomeView: View {

    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var isShowingProfile = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                headerView
                vpnStatusCard
                serverSelectionView
                Spacer()
            }
            .sheet(isPresented: $isShowingProfile) {
                ProfileView()
            }
            .navigationBarHidden(true)
        }
    }

    private var headerView: some View {
        HStack {
            Text("Welcome to PlanetProxy")
                .font(.title)
                .bold()
            Spacer()
            Button(action: {
                isShowingProfile.toggle()
            }) {
                Image(systemName: "person.circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }

    private var vpnStatusCard: some View {
        VStack(spacing: 15) {
            Image(systemName: "shield.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("VPN Status: Disconnected")
                .font(.headline)

            Button(action: {
                // TODO: Connect VPN
            }) {
                Text("Connect")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .padding(.horizontal)
    }

    private var serverSelectionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Server")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(["United States", "Germany", "Japan", "Singapore"], id: \.self) { country in
                        serverCard(for: country)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func serverCard(for country: String) -> some View {
        VStack {
            Image(systemName: "globe")
                .font(.system(size: 30))
            Text(country)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
}

struct ProfileView: View {

    @EnvironmentObject var authViewModel: AuthViewModel


    var body: some View {
        NavigationView {
            List {
                profileHeader
                settingsSection
                signOutSection
            }
            .navigationTitle("Profile")
            .listStyle(InsetGroupedListStyle())
        }
    }

    private var profileHeader: some View {
        Section {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    if let email = Auth.auth().currentUser?.email {
                        Text(email)
                            .font(.headline)
                    }
                    Text("Premium Member")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical)
        }
    }

    private var settingsSection: some View {
        Section {
            NavigationLink(destination: Text("Account Settings")) {
                Label("Account Settings", systemImage: "gear")
            }
            NavigationLink(destination: Text("Privacy Policy")) {
                Label("Privacy Policy", systemImage: "hand.raised.fill")
            }
            NavigationLink(destination: Text("Help & Support")) {
                Label("Help & Support", systemImage: "questionmark.circle.fill")
            }
        }
    }

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
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(AuthViewModel())
    }
}
