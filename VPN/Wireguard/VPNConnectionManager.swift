import Foundation
import NetworkExtension
import WireGuardKit
import os.log

class VPNConnectionManager {
    static let shared = VPNConnectionManager()
    weak var delegate: VPNManagerDelegate?
    
    private let logger = Logger(subsystem: "net.planet-proxy.VPN", category: "VPNManager")
    private var tunnelManager: NETunnelProviderManager?
    private var observerAdded = false
    
    private init() {
        setupVPNObserver()
        loadVPNConfiguration()
    }
    
    private func setupVPNObserver() {
        guard !observerAdded else { return }
        
        NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let connection = notification.object as? NEVPNConnection else { return }
            self?.handleVPNStatusChange(connection.status)
        }
        observerAdded = true
    }
    
    private func handleVPNStatusChange(_ status: NEVPNStatus) {
        logger.debug("VPN status changed: \(status.rawValue)")
        let vpnStatus: VPNConnectionStatus
        
        switch status {
        case .invalid:
            vpnStatus = .failed(.tunnelConfigurationFailed)
        case .disconnected:
            vpnStatus = .disconnected
        case .connecting:
            vpnStatus = .connecting
        case .connected:
            vpnStatus = .connected
        case .disconnecting:
            vpnStatus = .disconnecting
        case .reasserting:
            vpnStatus = .connecting
        @unknown default:
            vpnStatus = .disconnected
        }
        
        delegate?.vpnStatusDidChange(vpnStatus)
    }
    
    private func loadVPNConfiguration() {
        Task {
            do {
                let managers = try await NETunnelProviderManager.loadAllFromPreferences()
                tunnelManager = managers.first ?? NETunnelProviderManager()
                logger.debug("Loaded VPN configuration")
            } catch {
                logger.error("Failed to load VPN configuration: \(error.localizedDescription)")
                delegate?.vpnDidFail(with: .loadConfigurationFailed)
            }
        }
    }
    
    func configureVPN() async throws {
        do {
            let manager = tunnelManager ?? NETunnelProviderManager()
            let tunnelProtocol = NETunnelProviderProtocol()
            
            // Configure the protocol
            tunnelProtocol.providerBundleIdentifier = "net.planet-proxy.VPN.ProxyPro"
            tunnelProtocol.serverAddress = "WireGuard VPN"
            
            // Parse and validate WireGuard configuration
            guard let _ = try? TunnelConfiguration(fromWgQuickConfig: WireGuardConfig.config) else {
                throw VPNError.invalidWireGuardConfig
            }
            
            // Set WireGuard configuration
            tunnelProtocol.providerConfiguration = [
                "wgQuickConfig": WireGuardConfig.config
            ]
            
            manager.protocolConfiguration = tunnelProtocol
            manager.localizedDescription = "Planet Proxy VPN"
            manager.isEnabled = true
            
            try await manager.saveToPreferences()
            try await manager.loadFromPreferences()
            
            self.tunnelManager = manager
            logger.info("VPN configured successfully")
            
        } catch {
            logger.error("Failed to configure VPN: \(error.localizedDescription)")
            throw VPNError.systemConfigurationFailed
        }
    }
    
    func connect() async throws {
        guard let manager = tunnelManager else {
            try await configureVPN()
        }
        
        do {
            guard let session = tunnelManager?.connection as? NETunnelProviderSession else {
                throw VPNError.tunnelConfigurationFailed
            }
            
            try session.startVPNTunnel()
            logger.info("VPN connection started")
            
        } catch {
            logger.error("Failed to start VPN: \(error.localizedDescription)")
            throw VPNError.tunnelStartFailed(error.localizedDescription)
        }
    }
    
    func disconnect() async throws {
        guard let manager = tunnelManager else {
            return
        }
        
        do {
            manager.connection.stopVPNTunnel()
            logger.info("VPN disconnected")
            
        } catch {
            logger.error("Failed to stop VPN: \(error.localizedDescription)")
            throw VPNError.tunnelStopFailed(error.localizedDescription)
        }
    }
    
    func getCurrentStatus() -> VPNConnectionStatus {
        guard let status = tunnelManager?.connection.status else {
            return .disconnected
        }
        
        switch status {
        case .invalid:
            return .failed(.tunnelConfigurationFailed)
        case .disconnected:
            return .disconnected
        case .connecting:
            return .connecting
        case .connected:
            return .connected
        case .disconnecting:
            return .disconnecting
        case .reasserting:
            return .connecting
        @unknown default:
            return .disconnected
        }
    }
}
