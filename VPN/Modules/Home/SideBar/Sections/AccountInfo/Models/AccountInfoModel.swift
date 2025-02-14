import Foundation

struct AccountInfoModel: Codable {
    let id: Int
    let deviceId: String
    let uid: String
    let isActive: Bool
    let provider: String
    let profileUrl: String
    let name: String
    let email: String
    let createdTime: String
    let updatedTime: String
}
