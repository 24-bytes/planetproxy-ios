import SwiftUI

struct AccountInfoView: View {
    @State private var selectedTab = "Profile"
    @StateObject private var viewModel = AccountInfoViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    let navigation: NavigationCoordinator
    
    var body: some View {
        VStack {
            ToolbarView(title: String(localized: "account_information"), navigation: navigation)
          
           
ProfileView(accountInfo: viewModel.accountInfo, authViewModel: authViewModel)

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
                    AnalyticsManager.shared.trackEvent(EventName.VIEW.ACCOUNT_INFORMATION) // Track screen view event
                    viewModel.fetchAccountData()
                }
        .navigationBarBackButtonHidden(true)
    }
}
