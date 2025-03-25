//
//  VpnSession.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct VpnSession: Codable {
    public let id: Int
    public let serverId: Int
    public let publicKey: String
    public let localAddress: String
    public let sessionId: String
    public let persistentKeepAlive: Int
    public let allowedIps: String
    public let countryId: Int
    public let userSessionId: Int?
    public let privateKey: String
    public let endPoint: String
    public let dnsAddress: String
    public let isActive: Int
    
    public init(id: Int, serverId: Int, publicKey: String, localAddress: String, sessionId: String, persistentKeepAlive: Int, allowedIps: String, countryId: Int, userSessionId: Int?, privateKey: String, endPoint: String, dnsAddress: String, isActive: Int) {
        self.id = id
        self.serverId = serverId
        self.publicKey = publicKey
        self.localAddress = localAddress
        self.sessionId = sessionId
        self.persistentKeepAlive = persistentKeepAlive
        self.allowedIps = allowedIps
        self.countryId = countryId
        self.userSessionId = userSessionId
        self.privateKey = privateKey
        self.endPoint = endPoint
        self.dnsAddress = dnsAddress
        self.isActive = isActive
    }
}
