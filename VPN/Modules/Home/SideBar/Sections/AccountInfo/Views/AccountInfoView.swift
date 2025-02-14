import SwiftUI

struct AccountInfoView: View {
    @State private var selectedTab = "Profile"
    @StateObject private var viewModel = AccountInfoViewModel()

    var body: some View {
        VStack {
            // ✅ Header Section (Back Button + Title)
            HStack {
                Button(action: { /* Navigate Back */ }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }

                Spacer()

                Text("Account information")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // ✅ Tab Selector
            VPNServerTabView(selectedTab: $selectedTab, tabs: ["Profile", "Subscription"])

            // ✅ Content Based on Selected Tab
            selectedTabView
            
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.fetchAccountData()
        }
    }

    // ✅ View Based on Selected Tab
    @ViewBuilder
    private var selectedTabView: some View {
        switch selectedTab {
        case "Profile":
            ProfileView(accountInfo: viewModel.accountInfo)
        case "Subscription":
            SubscriptionView()
        case "Security":
            SecurityView()
        default:
            ProfileView(accountInfo: viewModel.accountInfo)
        }
    }
}
