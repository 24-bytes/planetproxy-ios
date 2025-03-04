import Foundation

protocol AccountRepositoryProtocol {
    func fetchUserInfo() async throws -> AccountInfoModel
}

class AccountRepository: AccountRepositoryProtocol {
    private let vpnRemoteService: VpnRemoteServiceProtocol

    init(vpnRemoteService: VpnRemoteServiceProtocol = VpnRemoteService()) {
        self.vpnRemoteService = vpnRemoteService
    }

    func fetchUserInfo() async throws -> AccountInfoModel {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken") else {
            print("❌ No auth token found. User may not be logged in.")
            throw APIError.unauthorized
        }

        do {
            print("🔄 Fetching user info from API with token: \(authToken.prefix(10))...") // ✅ Debugging print
            let userInfo = try await vpnRemoteService.getUser(authToken: authToken) // ✅ Now passing the token
            print("✅ User info received: \(userInfo)") // ✅ Print fetched data
            return userInfo
        } catch {
            print("❌ Error fetching user info: \(error.localizedDescription)") // ✅ Error log
            throw error
        }
    }

}
