import Foundation

struct VPNServer: Identifiable {
    let id = UUID()
    var country: String
    var city: String
    var pingTime: Int
    var isPremium: Bool
    var flag: String
}
