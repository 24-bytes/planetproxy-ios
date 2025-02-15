//
//  VPNConnectionViewModel.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 15/02/25.
//

import Foundation

@MainActor
class VPNConnectionViewModel: ObservableObject {
    @Published var isConnected: Bool = false

    func connectToServer(_ server: VPNServerModel) async {
        do {
            let _ = try await VPNConnectionManager.shared.fetchAndDecodePeer(for: server.countryId)
            VPNConnectionManager.shared.connectToVPN() // ✅ Removed `try` since it doesn’t throw

            DispatchQueue.main.async { [weak self] in
                self?.isConnected = true
            }
        } catch {
            print("Connection error: \(error.localizedDescription)")
        }
    }

    func disconnectServer() {
        VPNConnectionManager.shared.disconnectVPN()
        
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = false
        }
    }
}
