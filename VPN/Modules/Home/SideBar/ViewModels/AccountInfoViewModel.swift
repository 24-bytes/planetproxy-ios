import SwiftUI
import Combine

class AccountInfoViewModel: ObservableObject {
    @Published var user: UserModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let vpnRemoteService: VpnRemoteServiceProtocol

    init(vpnRemoteService: VpnRemoteServiceProtocol = VpnRemoteService()) {
        self.vpnRemoteService = vpnRemoteService
    }

    func fetchUserData() {
        Task {
            isLoading = true
            do {
                let fetchedUser = try await vpnRemoteService.getUser()
                DispatchQueue.main.async {
                    self.user = fetchedUser
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
