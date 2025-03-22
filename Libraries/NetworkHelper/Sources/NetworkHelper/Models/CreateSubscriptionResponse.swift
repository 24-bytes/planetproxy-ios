//
//  CreateSubscriptionResponse.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct CreateSubscriptionResponse: Codable {
    let id: String
    let entity: String
    let planId: String
    let status: String
    let currentStart: Int?
    let currentEnd: Int?
    let endedAt: Int?
    let quantity: Int
    let notes: [String]
    let chargeAt: Int?
    let startAt: Int?
    let endAt: Int?
    let authAttempts: Int
    let totalCount: Int
    let paidCount: Int
    let customerNotify: Bool
    let createdAt: Int
    let expireBy: Int?
    let shortUrl: String
    let hasScheduledChanges: Bool
    let changeScheduledAt: Int?
    let source: String
    let remainingCount: Int
}
