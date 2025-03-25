//
//  BaseResponseData.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

public struct BaseResponseData<T: Codable>: Codable {
    public let success: Bool
    public let message: String?
    public let data: T?
    
    public init(success: Bool, message: String?, data: T?) {
        self.success = success
        self.message = message
        self.data = data
    }
}
