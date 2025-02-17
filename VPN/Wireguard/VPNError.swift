//
//  VPNError.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 16/02/25.
//

import Foundation
import NetworkExtension

enum VPNError: LocalizedError {
    case tunnelConfigurationFailed
    case invalidConfiguration
    case tunnelStartFailed(String)
    case tunnelStopFailed(String)
    case systemConfigurationFailed
    case loadConfigurationFailed
    case saveConfigurationFailed
    case missingPermissions
    case invalidWireGuardConfig
    
    var errorDescription: String? {
        switch self {
        case .tunnelConfigurationFailed:
            return "Failed to configure VPN tunnel"
        case .invalidConfiguration:
            return "Invalid VPN configuration"
        case .tunnelStartFailed(let reason):
            return "Failed to start VPN tunnel: \(reason)"
        case .tunnelStopFailed(let reason):
            return "Failed to stop VPN tunnel: \(reason)"
        case .systemConfigurationFailed:
            return "Failed to configure system VPN settings"
        case .loadConfigurationFailed:
            return "Failed to load VPN configuration"
        case .saveConfigurationFailed:
            return "Failed to save VPN configuration"
        case .missingPermissions:
            return "VPN permissions not granted"
        case .invalidWireGuardConfig:
            return "Invalid WireGuard configuration"
        }
    }
}

enum VPNConnectionStatus: Equatable {
    case disconnected
    case connecting
    case connected
    case disconnecting
    case failed(VPNError)
    
    var description: String {
        switch self {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting..."
        case .connected:
            return "Connected"
        case .disconnecting:
            return "Disconnecting..."
        case .failed(let error):
            return "Failed: \(error.localizedDescription)"
        }
    }
    
    static func == (lhs: VPNConnectionStatus, rhs: VPNConnectionStatus) -> Bool {
        switch (lhs, rhs) {
        case (.disconnected, .disconnected),
             (.connecting, .connecting),
             (.connected, .connected),
             (.disconnecting, .disconnecting):
            return true
        case (.failed(let lhsError), .failed(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

protocol VPNManagerDelegate: AnyObject {
    func vpnStatusDidChange(_ status: VPNConnectionStatus)
    func vpnDidFail(with error: VPNError)
}
