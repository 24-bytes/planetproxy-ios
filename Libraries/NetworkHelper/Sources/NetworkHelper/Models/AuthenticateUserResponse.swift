//
//  AuthenticateUserResponse.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct AuthenticateUserResponse: Codable {
    public let token: String
    public let expiresIn: String
    
    public init(token: String, expiresIn: String) {
        self.token = token
        self.expiresIn = expiresIn
    }
}
