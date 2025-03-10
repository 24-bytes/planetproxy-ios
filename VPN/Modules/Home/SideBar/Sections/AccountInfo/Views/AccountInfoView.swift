import SwiftUI

struct AccountInfoView: View {
    @State private var selectedTab = "Profile"
    @StateObject private var viewModel = AccountInfoViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            ToolbarView(title: "Account Information")
          
           
ProfileView(accountInfo: viewModel.accountInfo, authViewModel: authViewModel)

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.fetchAccountData()
        }.navigationBarBackButtonHidden(true)
    }
}
