//
//  WireGuardConfig.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 16/02/25.
//

import Foundation

struct WireGuardConfig {
    static let config = """
    [Interface]
    PrivateKey = EK9vI5t3PsLrbj8+QNNGuvgxuvWiOQgTXITD/GCT0kY=
    Address = 10.0.0.2/32
    MTU = 1420
    DNS = 1.1.1.1

    [Peer]
    PublicKey = eNbLo3tabMFyrZEg4s5BA3Nqm23G97JwzAX1QoCUfnU=
    AllowedIPs = 0.0.0.0/0
    Endpoint = 194.164.127.128:65141
    PersistentKeepalive = 21
    """
}
