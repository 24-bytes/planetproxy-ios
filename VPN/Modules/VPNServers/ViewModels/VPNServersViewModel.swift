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

            // Group by country and convert to VPNServerCountryModel
            let groupedServers = Dictionary(grouping: serverList) { $0.countryId }
                .map { VPNServerCountryModel(
                    id: $0.key,
                    countryName: $0.value.first?.countryName ?? "",
                    countryFlagUrl: $0.value.first?.countryFlagUrl ?? "",
                    isPremium: $0.value.first?.isPremium ?? false,
                    servers: $0.value
                ) }
                .sorted { $0.countryName < $1.countryName }

            self.servers = groupedServers
            
            AnalyticsManager.shared.trackEvent(EventName.ON.SERVERS_LOADED)
            
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func filteredServers() -> [VPNServerCountryModel] {
        let filtered = servers.filter { country in
            switch selectedTab {
            case "Gaming":
                return country.servers.contains { $0.purpose.lowercased() == "game" }
            case "Browsing":
                return country.servers.contains { $0.purpose.lowercased() == "safe-browsing" }
            default:
                return true
            }
        }

        if searchQuery.isEmpty {
            return filtered
        } else {
            return filtered.filter { country in
                country.countryName.localizedCaseInsensitiveContains(searchQuery) ||
                country.servers.contains { $0.region.localizedCaseInsensitiveContains(searchQuery) }
            }
        }
    }
}
