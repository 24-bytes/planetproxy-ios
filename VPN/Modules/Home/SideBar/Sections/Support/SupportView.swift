import SwiftUI
import FreshchatSDK

struct SupportView: View {
    @StateObject private var viewModel = AccountInfoViewModel()
    @State private var showFreshchat = false
    @State private var showLoginScreen = false
    let navigation: NavigationCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Need Help?")
                .font(.title)
                .foregroundColor(.white)
            
            if viewModel.accountInfo != nil {
                // ✅ User is logged in, show Freshchat button
                Button(action: {
                    showFreshchat = true
                }) {
                    Text("Chat with Support")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showFreshchat) {
                    FreshchatView()
                        .edgesIgnoringSafeArea(.all)
                }
            } else {
                // ❌ User is not logged in, show login prompt
                VStack(spacing: 10) {
                    Text("Please log in to contact support.")
                        .foregroundColor(.gray)
                    
                    Button(action:{ navigation.navigateToLogin() }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.fetchAccountData()
        }
    }

}
