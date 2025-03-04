// MARK: - WireguardkitApp.swift

import NetworkExtension
class WireguardkitApp {
    
    func turnOnTunnel(countryId: Int, completionHandler: @escaping (Bool) -> Void) {
        WireGuardHandler.shared.fetchAndApplyPeerConfiguration(for: countryId, providerBundleIdentifier: "net.planet-proxy.VPN.network-extension") { error in
            if let error = error {
                NSLog("Failed to fetch and apply tunnel configuration: \(error.localizedDescription)")
                completionHandler(false)
                return
            }

            NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
                if let error = error {
                    NSLog("Error (loadAllFromPreferences): \(error)")
                    completionHandler(false)
                    return
                }

                guard let tunnelManager = tunnelManagersInSettings?.first else {
                    NSLog("No VPN configurations found.")
                    completionHandler(false)
                    return
                }

                do {
                    NSLog("Starting the tunnel")
                    guard let session = tunnelManager.connection as? NETunnelProviderSession else {
                        fatalError("tunnelManager.connection is invalid")
                    }
                    try session.startTunnel()
                    completionHandler(true)
                } catch {
                    NSLog("Error (startTunnel): \(error)")
                    completionHandler(false)
                }
            }
        }
    }

    func removeTunnel(completionHandler: @escaping (Bool) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
            if let error = error {
                NSLog("Error (loadAllFromPreferences): \(error)")
                completionHandler(false)
                return
            }

            guard let tunnelManager = tunnelManagersInSettings?.first else {
                NSLog("No existing tunnel found to remove.")
                completionHandler(true)
                return
            }

            tunnelManager.removeFromPreferences { error in
                if let error = error {
                    NSLog("Error (removeFromPreferences): \(error)")
                    completionHandler(false)
                    return
                }
                NSLog("Tunnel configuration removed successfully.")
                completionHandler(true)
            }
        }
    }

    func turnOffTunnel() {
        NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
            if let error = error {
                NSLog("Error (loadAllFromPreferences): \(error)")
                return
            }
            if let tunnelManager = tunnelManagersInSettings?.first {
                guard let session = tunnelManager.connection as? NETunnelProviderSession else {
                    fatalError("tunnelManager.connection is invalid")
                }
                switch session.status {
                case .connected, .connecting, .reasserting:
                    NSLog("Stopping the tunnel")
                    session.stopTunnel()
                default:
                    break
                }
            }
        }
    }
}
