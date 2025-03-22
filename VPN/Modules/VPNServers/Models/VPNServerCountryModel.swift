import Foundation

struct VPNServerCountryModel: Identifiable {
    let id: Int
    let countryName: String
    let countryFlagUrl: String
    let isPremium: Bool
    var servers: [VPNServerModel]
}

