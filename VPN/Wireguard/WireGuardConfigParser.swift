import Foundation
import WireGuardKit

struct WireGuardConfigParser {
    static func parse(_ configString: String) throws -> TunnelConfiguration {
        let tunnelConfig = try tunnel(fromWgQuickConfig: configString)

        guard let interface = tunnelConfig.interface, let peer = tunnelConfig.peers.first else {
            throw NSError(domain: "WireGuardConfigParserError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid WireGuard config"])
        }

        return TunnelConfiguration(
            privateKey: interface.privateKey.base64Key,
            address: interface.addresses.first?.string ?? "",
            dns: interface.dns.map { $0.string }.joined(separator: ","),
            peerPublicKey: peer.publicKey.base64Key,
            allowedIPs: peer.allowedIPs.map { $0.string }.joined(separator: ","),
            endpoint: peer.endpoint?.string ?? ""
        )
    }
}
