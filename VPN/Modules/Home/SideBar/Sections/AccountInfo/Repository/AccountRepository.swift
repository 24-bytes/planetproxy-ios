import Foundation
import FirebaseAuth
import NetworkHelper

protocol AccountRepositoryProtocol {
    func fetchUserInfo() async throws -> AccountInfoModel
}

class AccountRepository: AccountRepositoryProtocol {
    private let vpnService = VpnRemoteService()

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
