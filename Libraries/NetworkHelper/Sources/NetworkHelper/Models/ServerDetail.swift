//
//  ServerDetail.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct ServerDetail: Codable {
    public let serverId: Int
    public let countryName: String
    public let serverName: String
    public let purpose: String
    public let countryFlagUrl: String
    public let stealth: String
    public let region: String
    public let latency: Int
    public let signalStrength: Int
    public let serversCount: Int
    public let isPremium: Int
    public let isDefault: Int
    public let isActive: Int
    public let countryId: Int
    public let ipAddress: String
    
    public init(serverId: Int, countryName: String, serverName: String, purpose: String, countryFlagUrl: String, stealth: String, region: String, latency: Int, signalStrength: Int, serversCount: Int, isPremium: Int, isDefault: Int, isActive: Int, countryId: Int, ipAddress: String) {
        self.serverId = serverId
        self.countryName = countryName
        self.serverName = serverName
        self.purpose = purpose
        self.countryFlagUrl = countryFlagUrl
        self.stealth = stealth
        self.region = region
        self.latency = latency
        self.signalStrength = signalStrength
        self.serversCount = serversCount
        self.isPremium = isPremium
        self.isDefault = isDefault
        self.isActive = isActive
        self.countryId = countryId
        self.ipAddress = ipAddress
    }
}
