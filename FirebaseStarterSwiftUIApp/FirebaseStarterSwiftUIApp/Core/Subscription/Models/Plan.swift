import Foundation

struct Plan: Identifiable {
    let id = UUID()
    var name: String
    var price: Double
    var duration: String
    var features: [String]
    var dataLimit: Int // in GB
    var maxUsers: Int
    var isPremium: Bool
}
