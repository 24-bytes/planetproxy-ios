import SwiftUI

struct AccountInfoView: View {
    @State private var selectedTab = "Profile"
    @StateObject private var viewModel = AccountInfoViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            ToolbarView(title: "Account Information")
            // ✅ Tab Selector
            VPNServerTabView(selectedTab: $selectedTab, tabs: ["Profile"])

            // ✅ Content Based on Selected Tab
            selectedTabView
            
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.fetchAccountData()
        }.navigationBarBackButtonHidden(true)
    }

    // ✅ View Based on Selected Tab
    @ViewBuilder
    private var selectedTabView: some View {
        switch selectedTab {
        case "Profile":
            ProfileView(accountInfo: viewModel.accountInfo, authViewModel: authViewModel)
        case "Subscription":
            SubscriptionView()
        case "Security":
            SecurityView()
        default:
            ProfileView(accountInfo: viewModel.accountInfo, authViewModel: authViewModel)
        }
    }
}
