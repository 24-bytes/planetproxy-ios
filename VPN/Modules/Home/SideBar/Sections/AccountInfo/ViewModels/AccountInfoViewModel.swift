import SwiftUI
import FreshchatSDK

class AccountInfoViewModel: ObservableObject {
    @Published var accountInfo: AccountInfoModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let fetchAccountInfoUseCase: FetchAccountInfoUseCaseProtocol

    init(fetchAccountInfoUseCase: FetchAccountInfoUseCaseProtocol = FetchAccountInfoUseCase()) {
        self.fetchAccountInfoUseCase = fetchAccountInfoUseCase
    }

    func fetchAccountData() {
        Task {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            do {
                let userData = try await fetchAccountInfoUseCase.execute()
                DispatchQueue.main.async {
                    self.accountInfo = userData
                    self.isLoading = false
                    
                    // ✅ Set Freshchat User Data
                    let freshchatUser = FreshchatUser.sharedInstance()
                    freshchatUser.firstName = userData.displayName
                    freshchatUser.email = userData.email
                    Freshchat.sharedInstance().setUser(freshchatUser)
                    
                    AnalyticsManager.shared.setUser(
                        userId: userData.userId,
                        email: userData.email,
                        name: userData.displayName
                    )
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

}
