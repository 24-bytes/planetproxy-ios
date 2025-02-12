//
//  EndSessionRequest.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

struct EndSessionRequest: Codable {
    let peerId: Int
    let sessionId: Int
}
