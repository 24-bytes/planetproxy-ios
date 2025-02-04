//
//  AuthError.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//


// MARK: - AuthError Enum
enum AuthError: Error {
    case userNotFound
    case wrongPassword
    case emailAlreadyInUse
    case unknown(Error)
}
