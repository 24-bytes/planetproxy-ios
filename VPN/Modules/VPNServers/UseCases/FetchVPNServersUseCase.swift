import Foundation

class FetchVPNServersUseCase {
    private let repository: VPNServerRepositoryProtocol

    init(repository: VPNServerRepositoryProtocol = VPNServerRepository()) {
        self.repository = repository
    }

    func execute() async throws -> [VPNServerModel] {
        return try await repository.fetchVPNServers()
    }
}
