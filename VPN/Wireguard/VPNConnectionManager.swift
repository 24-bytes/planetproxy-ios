import Foundation
import UIKit
import NetworkExtension
import Combine

// MARK: - VPN Connection Status
enum VPNConnectionStatus: Equatable {
    case disconnected
    case connecting
    case connected
    case disconnecting
    case invalid
    case error(Error)
    
    var description: String {
        switch self {
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        case .disconnecting: return "Disconnecting"
        case .invalid: return "Invalid"
        case .error(let error): return "Error: \(error.localizedDescription)"
        }
    }
    
    static func == (lhs: VPNConnectionStatus, rhs: VPNConnectionStatus) -> Bool {
        switch (lhs, rhs) {
        case (.disconnected, .disconnected),
             (.connecting, .connecting),
             (.connected, .connected),
             (.disconnecting, .disconnecting),
             (.invalid, .invalid):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

// MARK: - VPN Server Info
struct VPNServerInfo {
    let id: Int
    let countryId: Int
    let endpoint: String
    let port: Int
    let publicKey: String
    let allowedIPs: String
    let dns: String
    let persistentKeepAlive: Int
}

// MARK: - VPN Connection Manager
class VPNConnectionManager: ObservableObject {
    static let shared = VPNConnectionManager()
    
    // MARK: - Published Properties
    @Published private(set) var connectionStatus: VPNConnectionStatus = .disconnected
    @Published private(set) var selectedServer: VPNServerModel?
    @Published private(set) var isConfigurationSaved: Bool = false
    @Published private(set) var lastError: Error?
    
    // UserDefaults keys
    private let selectedServerKey = "selectedServer"
    
    // MARK: - Private Properties
    private var statusObserver: Any?
    private var tunnelManager: NETunnelProviderManager?
    private var cancellables = Set<AnyCancellable>()
    private let wireGuardHandler = WireGuardHandler.shared
    private var sessionId: Int?
    private var GlobalpeerId: Int?
    
    private var isSessionStarting = false  // Prevents multiple session starts
    private let vpnRemoteService: VpnRemoteServiceProtocol
    
    
    private init(vpnRemoteService: VpnRemoteServiceProtocol = VpnRemoteService()) {
        self.vpnRemoteService = vpnRemoteService
        setupStatusObserver()
        loadSavedConfiguration()
        loadSelectedServer()
        monitorVpnStatus()
    }
    
    // MARK: - Public Methods
    
    /// Set the selected server without connecting
    func selectServer(_ server: VPNServerModel) {
        selectedServer = server
        saveSelectedServer(server)
    }
    
    /// Connect to the currently selected server
    func connectToSelectedServer() {
        guard let server = selectedServer else { return }
        
        let serverInfo = VPNServerInfo(
            id: server.id,
            countryId: server.countryId,
            endpoint: server.ipAddress,
            port: 51820,
            publicKey: "",
            allowedIPs: "0.0.0.0/0",
            dns: "1.1.1.1",
            persistentKeepAlive: 25
        )
        
        wireGuardHandler.fetchAndApplyPeerConfiguration(
            for: server.countryId,
            providerBundleIdentifier: "net.planet-proxy.VPN.network-extension"
        ) { [weak self] error in
            if let error = error {
                self?.updateStatus(.error(error))
            }
            self?.getSavedConfiguration { manager in
                        guard let session = manager?.connection as? NETunnelProviderSession else { return }
                VPNMetricsManager.shared.startMonitoring(session: session) // ✅ Start tracking metrics
                    }
        }
    }
    
    /// Disconnect from current VPN connection
    func disconnect() {
        guard let session = tunnelManager?.connection as? NETunnelProviderSession else {
            updateStatus(.error(NSError(domain: "VPNError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No active VPN session"])))
            return
        }
        
        session.stopTunnel()
        VPNMetricsManager.shared.stopMonitoring() // ✅ Stop tracking metrics
    }
    
    /// Get saved tunnel configuration
    func getSavedConfiguration(completion: @escaping (NETunnelProviderManager?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            self?.tunnelManager = managers?.first
            completion(managers?.first)
        }
    }
    
    /// Remove saved tunnel configuration
    func removeSavedConfiguration(completion: @escaping (Error?) -> Void) {
        guard let manager = tunnelManager else {
            completion(nil)
            return
        }
        
        manager.removeFromPreferences { error in
            if error == nil {
                self.tunnelManager = nil
                self.selectedServer = nil
                self.isConfigurationSaved = false
            }
            completion(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func saveSelectedServer(_ server: VPNServerModel) {
        if let encoded = try? JSONEncoder().encode(server) {
            UserDefaults.standard.set(encoded, forKey: selectedServerKey)
        }
    }
    
    private func loadSelectedServer() {
        if let savedServer = UserDefaults.standard.data(forKey: selectedServerKey),
           let server = try? JSONDecoder().decode(VPNServerModel.self, from: savedServer) {
            selectedServer = server
        }
    }
    
    private func setupStatusObserver() {
        if let observer = statusObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        statusObserver = NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let connection = notification.object as? NETunnelProviderSession else { return }

                switch connection.status {
                case .invalid:
                    self?.updateStatus(.invalid)
                case .disconnecting:
                    self?.updateStatus(.disconnecting)
                case .disconnected:
                    self?.updateStatus(.disconnected)
                    self?.endVpnSession()
                case .connecting:
                    self?.updateStatus(.connecting)
                case .connected:
                    self?.updateStatus(.connected)
                    self?.startVpnSession()
                case .reasserting:
                    self?.updateStatus(.connecting)
                @unknown default:
                    self?.updateStatus(.invalid)
                }
        }
    }

    
    private func loadSavedConfiguration() {
        getSavedConfiguration { [weak self] manager in
            self?.isConfigurationSaved = manager != nil
            
            // Update initial connection status
            if let status = manager?.connection.status {
                switch status {
                case .invalid:
                    self?.updateStatus(.invalid)
                case .disconnecting:
                    self?.updateStatus(.disconnecting)
                case .disconnected:
                    self?.updateStatus(.disconnected)
                case .connecting:
                    self?.updateStatus(.connecting)
                case .connected:
                    self?.updateStatus(.connected)
                case .reasserting:
                    self?.updateStatus(.connecting)
                @unknown default:
                    self?.updateStatus(.invalid)
                }
            }
        }
    }
    
    private func updateStatus(_ newStatus: VPNConnectionStatus) {
        DispatchQueue.main.async {
            self.connectionStatus = newStatus
            
            // Update last error if status contains error
            if case .error(let error) = newStatus {
                self.lastError = error
            }
            
            if newStatus == .connected {
                if let topViewController = UIApplication.shared.windows.first?.rootViewController {
                    AdsManager.shared.showAd(from: topViewController)
                }
            }
        }
    }
    
    // MARK: - Debug Methods
    #if DEBUG
    func printDebugInfo() {
        print("🔍 VPN Debug Info:")
        print("Connection Status: \(connectionStatus.description)")
        print("Configuration Saved: \(isConfigurationSaved)")
        if let server = selectedServer {
            print("Current Server:")
            print(" - ID: \(server.id)")
            print(" - Country ID: \(server.countryId)")
            print(" - Endpoint: \(server.ipAddress):\(51820)") // Default WireGuard port
        } else {
            print("No Current Server")
        }
        if let error = lastError {
            print("Last Error: \(error.localizedDescription)")
        }
    }
    #endif
}

// MARK: - Convenience Methods
extension VPNConnectionManager {
    var isConnected: Bool {
        connectionStatus == .connected
    }
    
    var isConnecting: Bool {
        connectionStatus == .connecting
    }
    
    var isDisconnecting: Bool {
        connectionStatus == .disconnecting
    }
    
    var hasError: Bool {
        if case .error(_) = connectionStatus {
            return true
        }
        return false
    }
    
    /// Start VPN session when connected

    private func startVpnSession() {
        guard let server = selectedServer else { return }
        
        // Prevent duplicate API calls
        guard !isSessionStarting else {
            print("⚠️ VPN session is already starting, skipping duplicate request.")
            return
        }
        
        // Check if a session already exists
        if sessionId != nil {
            print("✅ VPN session already active with sessionId: \(sessionId!)")
            return
        }
        
        isSessionStarting = true
        
        Task {
            do {
                guard let peerId = WireGuardHandler.shared.peerId else {
                    isSessionStarting = false
                    throw APIError.requestFailed("Peer ID not available")
                }

                let sessionResult = try await vpnRemoteService.startVpnSession(request: StartSessionRequest(peerId: peerId))
                
                GlobalpeerId = peerId
                sessionId = sessionResult.sessionId
                print("✅ VPN Session started with Peer ID: \(peerId) and Session ID: \(sessionId ?? -1)")

            } catch {
                print("❌ Failed to start VPN session: \(error.localizedDescription)")
            }
            
            isSessionStarting = false
        }
        ReviewManager.shared.requestReviewIfNeeded()

    }

    private func endVpnSession() {
        guard let sessionId = sessionId, let peerId = GlobalpeerId else {
            print("⚠️ No active session to end.")
            return
        }

        Task {
            do {
                try await vpnRemoteService.endVpnSession(request: EndSessionRequest(peerId: peerId, sessionId: sessionId))
                print("✅ VPN Session ended: sessionId=\(sessionId)")

                // Reset session tracking variables
                self.sessionId = nil
                self.GlobalpeerId = nil
            } catch {
                print("❌ Failed to end VPN session: \(error.localizedDescription)")
            }
        }
    }

    private func monitorVpnStatus() {
        let sharedDefaults = UserDefaults(suiteName: "group.net.planet-proxy.VPN")
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let isVpnActive = sharedDefaults?.bool(forKey: "vpnActive") ?? false
            
            if isVpnActive {
                if self.connectionStatus != .connected {
                    print("📡 Detected VPN start from Control Panel, syncing state...")
                    self.updateStatus(.connected)
                    self.startVpnSession()
                }
            } else {
                if self.connectionStatus == .connected {
                    print("📡 Detected VPN stop from Control Panel, syncing state...")
                    self.updateStatus(.disconnected)
                    self.endVpnSession()
                }
            }
        }
    }
}
