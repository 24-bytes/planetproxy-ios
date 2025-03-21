//
//  EndSessionRequest.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct EndSessionRequest: Codable {
    public let peerId: Int
    public let sessionId: Int

    public init(sessionId: Int, peerId: Int) { // ✅ Explicit initializer
        self.sessionId = sessionId
        self.peerId = peerId
    }
}
