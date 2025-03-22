import Foundation

struct VPNServerModel: Codable, Identifiable {
    let id: Int
    let serverName: String
    let countryName: String
    let purpose: String
    let countryFlagUrl: String
    let stealth: String
    let latency: Int
    let region: String
    let signalStrength: Int
    let serversCount: Int
    let isPremium: Bool
    let isDefault: Bool
    let isActive: Bool
    let countryId: Int
    let ipAddress: String

    enum CodingKeys: String, CodingKey {
        case id = "serverId"
        case serverName, countryName, purpose, countryFlagUrl, stealth, latency, region, signalStrength, serversCount, isPremium, isDefault, isActive, countryId, ipAddress
    }
}

