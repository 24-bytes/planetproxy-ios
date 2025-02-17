import Foundation
import Combine
import os.log

@MainActor
class VPNConnectionViewModel: ObservableObject, VPNManagerDelegate {
    @Published private(set) var connectionStatus: VPNConnectionStatus = .disconnected
    @Published private(set) var isConnecting = false
    @Published private(set) var errorMessage: String?
    
    private let vpnManager = VPNConnectionManager.shared
    private let logger = Logger(subsystem: "net.planet-proxy.VPN", category: "VPNViewModel")
    
    init() {
        vpnManager.delegate = self
        connectionStatus = vpnManager.getCurrentStatus()
    }
    
    func toggleConnection() {
        Task {
            do {
                isConnecting = true
                errorMessage = nil
                
                if connectionStatus == .connected {
                    try await vpnManager.disconnect()
                } else {
                    try await vpnManager.connect()
                }
            } catch {
                if let vpnError = error as? VPNError {
                    handleError(vpnError)
                } else {
                    handleError(.tunnelStartFailed(error.localizedDescription))
                }
            }
            isConnecting = false
        }
    }
    
    private func handleError(_ error: VPNError) {
        logger.error("VPN Error: \(error.localizedDescription)")
        errorMessage = error.localizedDescription
        connectionStatus = .failed(error)
    }
    
    // MARK: - VPNManagerDelegate
    
    func vpnStatusDidChange(_ status: VPNConnectionStatus) {
        Task { @MainActor in
            self.connectionStatus = status
            if case .failed(let error) = status {
                self.errorMessage = error.localizedDescription
            } else {
                self.errorMessage = nil
            }
        }
    }
    
    func vpnDidFail(with error: VPNError) {
        Task { @MainActor in
            handleError(error)
        }
    }
}
