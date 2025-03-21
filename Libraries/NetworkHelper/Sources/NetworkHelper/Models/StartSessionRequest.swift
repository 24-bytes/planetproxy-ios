//
//  StartSessionRequest.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct StartSessionRequest: Codable {
    public let peerId: Int
    
    public init(peerId: Int) { // ✅ Explicit initializer
        self.peerId = peerId
    }
}
