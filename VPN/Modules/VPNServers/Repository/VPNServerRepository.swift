import Foundation
import NetworkHelper

protocol VPNServerRepositoryProtocol {
    func fetchVPNServers() async throws -> [VPNServerModel]
}

class VPNServerRepository: VPNServerRepositoryProtocol {
    private let vpnService = VpnRemoteService()

    func fetchVPNServers() async throws -> [VPNServerModel] {

        do {
            let serverDetails = try await vpnService.getVpnServers()
            let vpnServers = serverDetails.map { serverDetail in
                VPNServerModel(
                    id: serverDetail.serverId,
                    serverName: serverDetail.serverName,
                    countryName: serverDetail.countryName,
                    purpose: serverDetail.purpose,
                    countryFlagUrl: serverDetail.countryFlagUrl,
                    stealth: serverDetail.stealth,
                    latency: serverDetail.latency,
                    region: serverDetail.region,
                    signalStrength: serverDetail.signalStrength,
                    serversCount: serverDetail.serversCount,
                    isPremium: serverDetail.isPremium == 1, // Convert Int to Bool
                    isDefault: serverDetail.isDefault == 1, // Convert Int to Bool
                    isActive: serverDetail.isActive == 1,   // Convert Int to Bool
                    countryId: serverDetail.countryId,
                    ipAddress: serverDetail.ipAddress
                )
            }
            return vpnServers
        } catch {
            throw error
        }
    }
}
