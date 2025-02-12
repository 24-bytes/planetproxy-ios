import SwiftUI

struct AccountInfoView: View {
    @State private var selectedTab = "Profile"
    @StateObject private var viewModel = AccountInfoViewModel()

    var body: some View {
        VStack {
            tabSelection
            selectedTabView
        }
        .onAppear {
            viewModel.fetchUserData()
        }
    }

    // ✅ Tabs Selection Bar
    private var tabSelection: some View {
        HStack {
            tabButton(title: "Profile", tab: "Profile")
            tabButton(title: "Subscription", tab: "Subscription")
            tabButton(title: "Security", tab: "Security")
        }
        .padding()
    }

    // ✅ View Based on Selected Tab
    @ViewBuilder
    private var selectedTabView: some View {
        switch selectedTab {
        case "Profile":
            ProfileView()
        case "Subscription":
            SubscriptionView()
        case "Security":
            SecurityView()
        default:
            ProfileView()
        }
    }

    // ✅ Tab Button
    private func tabButton(title: String, tab: String) -> some View {
        Button(action: { selectedTab = tab }) {
            Text(title)
                .foregroundColor(selectedTab == tab ? .purple : .gray)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .background(selectedTab == tab ? Color.purple.opacity(0.2) : Color.clear)
                .cornerRadius(8)
        }
    }
}

#Preview {
    AccountInfoView()
}
