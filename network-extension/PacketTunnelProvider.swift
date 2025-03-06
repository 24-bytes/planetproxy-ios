//
//  PacketTunnelProvider.swift
//  network-extension
//
//  Created by Haider on 18/12/2024.
//

import NetworkExtension
import WireGuardKit

enum PacketTunnelProviderError: String, Error {
    case invalidProtocolConfiguration
    case cantParseWgQuickConfig
}

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    private lazy var adapter: WireGuardAdapter = {
        return WireGuardAdapter(with: self) { [weak self] _, message in
            self?.log(message)
        }
    }()

    
    func log(_ message: String) {
        NSLog("WireGuard Tunnel: %@\n", message)
    }
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        log("Starting tunnel")
        guard let protocolConfiguration = self.protocolConfiguration as? NETunnelProviderProtocol,
              let providerConfiguration = protocolConfiguration.providerConfiguration,
              let wgQuickConfig = providerConfiguration["wgQuickConfig"] as? String else {
            log("Invalid provider configuration")
            completionHandler(PacketTunnelProviderError.invalidProtocolConfiguration)
            return
        }
        
        guard let tunnelConfiguration = try? TunnelConfiguration(fromWgQuickConfig: wgQuickConfig) else {
            log("wg-quick config not parseable")
            completionHandler(PacketTunnelProviderError.cantParseWgQuickConfig)
            return
        }
        
        adapter.start(tunnelConfiguration: tunnelConfiguration) { [weak self] adapterError in
            guard let self = self else { return }
            if let adapterError = adapterError {
                self.log("WireGuard adapter error: \(adapterError.localizedDescription)")
            } else {
                let interfaceName = self.adapter.interfaceName ?? "unknown"
                self.log("Tunnel interface is \(interfaceName)")
            }
            completionHandler(adapterError)
        }
    }
    
        override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
            // Add code here to start the process of stopping the tunnel.
            log("Stopping tunnel")
            adapter.stop { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.log("Failed to stop WireGuard adapter: \(error.localizedDescription)")
                }
                completionHandler()

                #if os(macOS)
                // HACK: We have to kill the tunnel process ourselves because of a macOS bug
                exit(0)
                #endif
            }
        }
        
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        guard let completionHandler = completionHandler else { return }
        
        // Ensure tunnel is active and interface name is available
        guard let interfaceName = adapter.interfaceName else {
            print("❌ Error: WireGuard interface is not available")
            completionHandler(nil)
            return
        }
        
        // Fetch network traffic stats
        getTunnelTraffic(interface: interfaceName) { txBytes, rxBytes in
            guard let txBytes = txBytes, let rxBytes = rxBytes else {
                print("❌ Error: Unable to retrieve tunnel traffic")
                completionHandler(nil)
                return
            }

            // Convert UInt64 values to Data
            var response = Data()
            var tx = txBytes
            var rx = rxBytes
            response.append(Data(bytes: &tx, count: MemoryLayout<UInt64>.size))
            response.append(Data(bytes: &rx, count: MemoryLayout<UInt64>.size))

            // Send stats back to VPNMetricsManager
            completionHandler(response)
        }
    }
    
    private func getTunnelTraffic(interface: String, completion: @escaping (UInt64?, UInt64?) -> Void) {
        var txBytes: UInt64 = 0
        var rxBytes: UInt64 = 0

        let stats = getifaddrsWrapper()
        for stat in stats {
            if stat.name == interface {
                txBytes += stat.txBytes
                rxBytes += stat.rxBytes
            }
        }

        completion(txBytes, rxBytes)
    }
    
    struct InterfaceStats {
        let name: String
        let txBytes: UInt64
        let rxBytes: UInt64
    }

    func getifaddrsWrapper() -> [InterfaceStats] {
        var results: [InterfaceStats] = []
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil

        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                if let name = ptr?.pointee.ifa_name {
                    let interface = String(cString: name)
                    let data = ptr?.pointee.ifa_data?.assumingMemoryBound(to: if_data.self)

                    let txBytes = UInt64(data?.pointee.ifi_obytes ?? 0)
                    let rxBytes = UInt64(data?.pointee.ifi_ibytes ?? 0)

                    results.append(InterfaceStats(name: interface, txBytes: txBytes, rxBytes: rxBytes))
                }
                ptr = ptr?.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }

        return results
    }


        
        override func sleep(completionHandler: @escaping () -> Void) {
            // Add code here to get ready to sleep.
            completionHandler()
        }
        
        override func wake() {
            // Add code here to wake up.
        }
    }
