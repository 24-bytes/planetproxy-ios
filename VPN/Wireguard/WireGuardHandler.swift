//
//  WireGuardHandler.swift
//  Wireguard-Solution
//
//  Created by Haider on 30/12/2024.
//

import Foundation
import NetworkExtension
import CommonCrypto
import Network

class WireGuardHandler {
    static let shared = WireGuardHandler()
    private let vpnRemoteService: VpnRemoteServiceProtocol
    //private var connectionMonitor: NWPathMonitor?
    private(set) var peerId: Int?
    
    private init(vpnRemoteService: VpnRemoteServiceProtocol = VpnRemoteService()) {
        self.vpnRemoteService = vpnRemoteService
        //setupConnectionMonitoring()
    }
    
//    private func setupConnectionMonitoring() {
//        connectionMonitor = NWPathMonitor()
//        connectionMonitor?.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                print("✅ Network connection available: \(path.isExpensive ? "Cellular" : "WiFi")")
//            } else {
//                print("❌ Network connection lost")
//            }
//        }
//        connectionMonitor?.start(queue: .main)
//    }
    
    // MARK: - Fetch and Apply VPN Configuration
    func fetchAndApplyPeerConfiguration(for countryId: Int, providerBundleIdentifier: String, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                print("🔍 Fetching encrypted peer data for countryId: \(countryId)")
                let encryptedPeerData = try await vpnRemoteService.getVpnSession(countryId: countryId)
                
                print("✅ Received Encrypted Data: \(encryptedPeerData)")
                
                guard let decryptedData = decryptWireGuardPeer(encryptedText: encryptedPeerData) else {
                    throw NSError(domain: "VPNError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decrypt peer data"])
                }
                
                print("✅ Decrypted Data Output: \(decryptedData)")
                
                let tunnelConfig = parseWireGuardConfiguration(decryptedData)
                print("✅ Parsed Tunnel Config: \(tunnelConfig)")
                
                // Apply configuration and start tunnel
                applyTunnelConfiguration(config: tunnelConfig, providerBundleIdentifier: providerBundleIdentifier) { error in
                    if let error = error {
                        print("❌ Configuration Error: \(error.localizedDescription)")
                        completion(error)
                        return
                    }
                    
                    // Load the manager again to start the tunnel
                    NETunnelProviderManager.loadAllFromPreferences { managers, error in
                        if let error = error {
                            print("❌ Load Error: \(error.localizedDescription)")
                            completion(error)
                            return
                        }
                        
                        guard let tunnelManager = managers?.first else {
                            print("❌ No tunnel configuration found")
                            completion(NSError(domain: "VPNError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No tunnel configuration found"]))
                            return
                        }
                        
                        // Check connection status
                        let status = tunnelManager.connection.status
                        print("📡 Current connection status: \(self.statusString(for: status))")
                        
                        // Ensure we have a valid session
                        guard let session = tunnelManager.connection as? NETunnelProviderSession else {
                            print("❌ Invalid tunnel session")
                            completion(NSError(domain: "VPNError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid tunnel session"]))
                            return
                        }
                        
                        do {
                            if status == .connected {
                                print("⚠️ Tunnel already connected, stopping first...")
                                session.stopTunnel()
                                // Wait briefly before reconnecting
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    do {
                                        print("🚀 Starting tunnel...")
                                        try session.startVPNTunnel()
                                        print("✅ Tunnel start initiated")
                                        completion(nil)
                                    } catch {
                                        print("❌ Failed to start tunnel: \(error.localizedDescription)")
                                        completion(error)
                                    }
                                }
                            } else {
                                print("🚀 Starting tunnel...")
                                try session.startVPNTunnel()
                                print("✅ Tunnel start initiated")
                                completion(nil)
                            }
                        } catch {
                            print("❌ Failed to start tunnel: \(error.localizedDescription)")
                            completion(error)
                        }
                    }
                }
            } catch {
                print("❌ Error: \(error.localizedDescription)")
                completion(error)
            }
        }
    }
    
    private func statusString(for status: NEVPNStatus) -> String {
        switch status {
        case .invalid: return "Invalid"
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        case .reasserting: return "Reasserting"
        case .disconnecting: return "Disconnecting"
        @unknown default: return "Unknown"
        }
    }
    
    // MARK: - Decrypt WireGuard Peer
    private func decryptWireGuardPeer(encryptedText: String) -> String? {
        let secretKey = "123DFGGJKL~~~FGH"
        
        // 1. Decode Base64
        guard let encryptedData = Data(base64Encoded: encryptedText) else {
            print("❌ Error: Failed to decode Base64")
            return nil
        }
        
        // 2. Prepare key (matching CryptoJS key derivation)
        var key = [UInt8](repeating: 0, count: kCCKeySizeAES128)
        let keyData = secretKey.data(using: .utf8)!
        keyData.withUnsafeBytes { keyBytes in
            // Copy up to 16 bytes (AES-128) from the key
            let count = min(keyData.count, kCCKeySizeAES128)
            memcpy(&key, keyBytes.baseAddress, count)
        }
        
        // 3. Setup decryption
        let bufferSize = encryptedData.count + kCCBlockSizeAES128
        var decryptBuffer = [UInt8](repeating: 0, count: bufferSize)
        var numBytesDecrypted = 0
        
        // 4. Decrypt using AES/ECB/PKCS7 (matching CryptoJS configuration)
        let status = encryptedData.withUnsafeBytes { dataBytes in
            CCCrypt(
                CCOperation(kCCDecrypt),
                CCAlgorithm(kCCAlgorithmAES),
                CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
                key,
                kCCKeySizeAES128,
                nil,
                dataBytes.baseAddress,
                encryptedData.count,
                &decryptBuffer,
                bufferSize,
                &numBytesDecrypted
            )
        }
        
        guard status == kCCSuccess else {
            print("❌ Error: Decryption failed with status: \(status)")
            return nil
        }
        
        // 5. Convert decrypted bytes to string
        let decryptedData = Data(decryptBuffer.prefix(numBytesDecrypted))
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            print("❌ Error: Failed to decode UTF8 string")
            print("Decrypted bytes (\(numBytesDecrypted)):")
            print(decryptBuffer.prefix(numBytesDecrypted).map { String(format: "%02x", $0) }.joined(separator: " "))
            return nil
        }
        
        // 6. Validate JSON
        guard let _ = try? JSONSerialization.jsonObject(with: decryptedData) else {
            print("❌ Error: Invalid JSON")
            print("Decrypted string: \(decryptedString)")
            return nil
        }
        
        // Parse JSON to extract peerId
        if let jsonData = decryptedString.data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
           let extractedPeerId = jsonObject["id"] as? Int {
            peerId = extractedPeerId
            print("✅ Stored Peer ID: \(peerId!)")
        } else {
            print("❌ Failed to extract peerId from decrypted data")
        }
        
        return decryptedString
    }
    
    // MARK: - Parse WireGuard Configuration
    private func parseWireGuardConfiguration(_ configString: String) -> [String: Any] {
        guard let jsonData = configString.data(using: .utf8),
              let peer = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            print("❌ Error: Failed to parse peer JSON")
            return [:]
        }
        
        // Convert JSON config to WireGuard format
        let wgQuickConfig = """
[Interface]
PrivateKey = \(peer["privateKey"] as? String ?? "")
Address = \(peer["localAddress"] as? String ?? "")
DNS = \(peer["dnsAddress"] as? String ?? "")

[Peer]
PublicKey = \(peer["publicKey"] as? String ?? "")
Endpoint = \(peer["endPoint"] as? String ?? ""):\(peer["port"] as? Int ?? 0)
AllowedIPs = \(peer["allowedIps"] as? String ?? "")
PersistentKeepalive = \(peer["persistentKeepAlive"] as? Int ?? 0)
"""
        
        print("📝 WireGuard Quick Config:")
        print(wgQuickConfig)
        
        return ["wgQuickConfig": wgQuickConfig]
    }
    
    // MARK: - Apply VPN Configuration
    private func applyTunnelConfiguration(config: [String: Any], providerBundleIdentifier: String, completion: @escaping (Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            if let error = error {
                print("❌ Error loading preferences: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            // Get existing or create new manager
            let tunnelManager = managers?.first ?? NETunnelProviderManager()
            
            // Configure the protocol
            let protocolConfiguration = NETunnelProviderProtocol()
            protocolConfiguration.providerBundleIdentifier = providerBundleIdentifier
            
            // Set server address from config
            if let wgConfig = config["wgQuickConfig"] as? String,
               let endpoint = wgConfig.components(separatedBy: .newlines)
                .first(where: { $0.contains("Endpoint") })?
                .components(separatedBy: "=").last?
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: ":").first {
                protocolConfiguration.serverAddress = endpoint
            }
            
            // Set the configuration
            protocolConfiguration.providerConfiguration = config
            
            // Configure the manager
            tunnelManager.protocolConfiguration = protocolConfiguration
            tunnelManager.localizedDescription = "WireGuard VPN"
            tunnelManager.isEnabled = true
            
            // Save and load the configuration
            tunnelManager.saveToPreferences { error in
                if let error = error {
                    print("❌ Error saving preferences: \(error.localizedDescription)")
                    completion(error)
                    return
                }
                
                tunnelManager.loadFromPreferences { error in
                    if let error = error {
                        print("❌ Error loading saved preferences: \(error.localizedDescription)")
                        completion(error)
                        return
                    }
                    
                    print("✅ VPN configuration applied successfully")
                    completion(nil)
                }
            }
        }
    }
}
