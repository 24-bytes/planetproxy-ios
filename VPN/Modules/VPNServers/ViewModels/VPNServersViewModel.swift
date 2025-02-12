
import Foundation
import SwiftUI

@MainActor
class VPNServersViewModel: ObservableObject {
    @Published var servers: [VPNServerCountryModel] = []
    @Published var searchQuery: String = ""
    @Published var selectedTab: String = "Default"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchServersUseCase = FetchVPNServersUseCase()

    func fetchServers() async {
        isLoading = true
        do {
            let serverList = try await fetchServersUseCase.execute()
            let groupedServers = Dictionary(grouping: serverList) { $0.countryId }
                .map { VPNServerCountryModel(id: $0.key, countryName: $0.value.first?.countryName ?? "", countryFlagUrl: $0.value.first?.countryFlagUrl ?? "", isPremium: $0.value.first?.isPremium ?? false, servers: $0.value) }
                .sorted { $0.countryName < $1.countryName }

            self.servers = groupedServers
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func filteredServers() -> [VPNServerCountryModel] {
        if searchQuery.isEmpty {
            return servers
        } else {
            return servers.filter { $0.countryName.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}
