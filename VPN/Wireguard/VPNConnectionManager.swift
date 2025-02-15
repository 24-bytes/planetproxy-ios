import Foundation
import NetworkExtension
import CommonCrypto

class VPNConnectionManager {
    static let shared = VPNConnectionManager()
    
    private var tunnel: TunnelConfiguration?
    
    func fetchAndDecodePeer(for countryId: Int) async throws -> TunnelConfiguration {
        let url = URL(string: "http://194.164.171.104:8080/api/peer/\(countryId)?purpose=gaming,streaming,general")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(PeerResponse.self, from: data)
        
        print("🔹 Encrypted peer data received: \(response.data)")

        guard let decryptedData = decryptWireGuardPeer(encryptedText: response.data) else {
            throw NSError(domain: "VPNError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decrypt peer data"])
        }

        print("✅ Decrypted WireGuard config:\n\(decryptedData)")

        let tunnelConfig = try WireGuardConfigParser.parse(decryptedData)
        self.tunnel = tunnelConfig
        return tunnelConfig
    }

    
    func connectToVPN() {
        guard let tunnel = tunnel else {
            print("No tunnel configuration available")
            return
        }

        let vpnManager = NEVPNManager.shared()
        vpnManager.loadFromPreferences { error in
            if let error = error {
                print("❌ Failed to load VPN preferences: \(error.localizedDescription)")
                return
            }

            let protocolConfig = NETunnelProviderProtocol()
            protocolConfig.providerBundleIdentifier = "net.planet-proxy.VPN.ProxyPro" // Ensure this matches your app extension!

            // ✅ Ensure proper WireGuard configuration format
            protocolConfig.providerConfiguration = [
                "PrivateKey": tunnel.privateKey,
                "Address": tunnel.address,
                "DNS": tunnel.dns,
                "PeerPublicKey": tunnel.peerPublicKey,
                "AllowedIPs": tunnel.allowedIPs,
                "Endpoint": tunnel.endpoint
            ]
            protocolConfig.disconnectOnSleep = false

            vpnManager.protocolConfiguration = protocolConfig
            vpnManager.isOnDemandEnabled = true
            vpnManager.isEnabled = true

            vpnManager.saveToPreferences { error in
                if let error = error {
                    print("❌ Failed to save VPN configuration: \(error.localizedDescription)")
                    return
                }
                do {
                    try vpnManager.connection.startVPNTunnel()
                    print("✅ VPN Connected Successfully")
                } catch {
                    print("❌ Error starting VPN tunnel: \(error.localizedDescription)")
                }
            }
        }
    }

    
    func disconnectVPN() {
        let vpnManager = NEVPNManager.shared()
        vpnManager.loadFromPreferences { error in
            if let error = error {
                print("Failed to load VPN preferences: \(error.localizedDescription)")
                return
            }
            vpnManager.connection.stopVPNTunnel()
        }
    }
    
    // AES Decryption using CommonCrypto
    private func decryptWireGuardPeer(encryptedText: String) -> String? {
        print("⚠️ Skipping AES decryption - Returning hardcoded WireGuard config")

        return """
        [Interface]
        PrivateKey = EK9vI5t3PsLrbj8+QNNGuvgxuvWiOQgTXITD/GCT0kY=
        Address = 10.0.0.2/32
        MTU = 1420
        DNS = 1.1.1.1
        [Peer]
        PublicKey = eNbLo3tabMFyrZEg4s5BA3Nqm23G97JwzAX1QoCUfnU=
        AllowedIPs = 0.0.0.0/0
        Endpoint = 194.164.127.128:65141
        PersistentKeepalive = 21
        """
    }

    
    private func deriveKey(from secret: String) -> Data {
        var key = secret.data(using: .utf8)!
        if key.count < kCCKeySizeAES256 {
            key.append(contentsOf: [UInt8](repeating: 0, count: kCCKeySizeAES256 - key.count))
        } else if key.count > kCCKeySizeAES256 {
            key = key.prefix(kCCKeySizeAES256) // Trim to required length
        }
        return key
    }


}

/// Struct to hold WireGuard Tunnel Configuration
struct TunnelConfiguration {
    let privateKey: String
    let address: String
    let dns: String
    let peerPublicKey: String
    let allowedIPs: String
    let endpoint: String
}

/// API Response Structure
struct PeerResponse: Codable {
    let success: Bool
    let code: Int
    let error: String
    let data: String
}
