import SwiftUI

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
            isLoading = true
            do {
                let userData = try await fetchAccountInfoUseCase.execute()
                DispatchQueue.main.async {
                    self.accountInfo = userData
                    self.isLoading = false
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
