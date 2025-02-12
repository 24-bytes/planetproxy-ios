import Foundation

protocol VPNServerRepositoryProtocol {
    func fetchVPNServers() async throws -> [VPNServerModel]
}

class VPNServerRepository: VPNServerRepositoryProtocol {
    private let apiClient = APIClient.shared

    func fetchVPNServers() async throws -> [VPNServerModel] {
        guard let url = APIEndpoints.Servers.getVpnServers()?.absoluteString else {
            throw APIError.invalidURL
        }
        return try await apiClient.request(url: url, method: .get)
    }
}
