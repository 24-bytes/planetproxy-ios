//
//  ServerDetail.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct ServerDetail: Codable {
    let serverId: Int
    let countryName: String
    let serverName: String
    let purpose: String
    let countryFlagUrl: String
    let stealth: String
    let region: String
    let latency: Int
    let signalStrength: Int
    let serversCount: Int
    let isPremium: Int
    let isDefault: Int
    let isActive: Int
    let countryId: Int
    let ipAddress: String
}
