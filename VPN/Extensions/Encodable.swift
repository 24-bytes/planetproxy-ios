//
//  Util.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dictionary = json as? [String: Any] else {
            throw APIError.decodingFailed
        }
        return dictionary
    }
}
