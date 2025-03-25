import Foundation

public struct AuthenticateUserRequest: Codable {
    public let deviceId: String
    
    public init(deviceId: String) {
        self.deviceId = deviceId
    }
}
