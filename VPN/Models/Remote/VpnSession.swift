//
//  VpnSession.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

struct VpnSession: Codable {
    let id: Int
    let serverId: Int
    let publicKey: String
    let localAddress: String
    let sessionId: String
    let persistentKeepAlive: Int
    let allowedIps: String
    let countryId: Int
    let userSessionId: Int?
    let privateKey: String
    let endPoint: String
    let dnsAddress: String
    let isActive: Int
}
