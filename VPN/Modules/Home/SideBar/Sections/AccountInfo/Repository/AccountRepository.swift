import Foundation
import FirebaseAuth

protocol AccountRepositoryProtocol {
    func fetchUserInfo() async throws -> AccountInfoModel
}

class AccountRepository: AccountRepositoryProtocol {
    private let vpnRemoteService: VpnRemoteServiceProtocol

    init(vpnRemoteService: VpnRemoteServiceProtocol = VpnRemoteService()) {
        self.vpnRemoteService = vpnRemoteService
    }

    func fetchUserInfo() async throws -> AccountInfoModel {
        guard let firebaseUser = Auth.auth().currentUser else {
                    print("❌ No authenticated Firebase user found.")
                    throw APIError.unauthorized
                }

        
        let userInfo = AccountInfoModel(
                    userId: firebaseUser.uid,
                    email: firebaseUser.email ?? "N/A",
                    displayName: firebaseUser.displayName ?? "Unknown User",
                    profilePictureURL: firebaseUser.photoURL?.absoluteString ?? "",
                    phoneNumber: firebaseUser.phoneNumber ?? ""
                )

        return userInfo
    }

}
