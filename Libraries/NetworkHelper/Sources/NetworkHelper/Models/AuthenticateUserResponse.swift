//
//  AuthenticateUserResponse.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct AuthenticateUserResponse: Codable {
    let token: String
    let expiresIn: String
}
