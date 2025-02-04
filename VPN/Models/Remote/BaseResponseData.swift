//
//  BaseResponseData.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

struct BaseResponseData<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
}
