//
//  CreateSubscriptionResponse.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//

import Foundation

public struct CreateSubscriptionResponse: Codable {
    public let id: String
    public let entity: String
    public let planId: String
    public let status: String
    public let currentStart: Int?
    public let currentEnd: Int?
    public let endedAt: Int?
    public let quantity: Int
    public let notes: [String]
    public let chargeAt: Int?
    public let startAt: Int?
    public let endAt: Int?
    public let authAttempts: Int
    public let totalCount: Int
    public let paidCount: Int
    public let customerNotify: Bool
    public let createdAt: Int
    public let expireBy: Int?
    public let shortUrl: String
    public let hasScheduledChanges: Bool
    public let changeScheduledAt: Int?
    public let source: String
    public let remainingCount: Int
    
    public init(id: String, entity: String, planId: String, status: String, currentStart: Int?, currentEnd: Int?, endedAt: Int?, quantity: Int, notes: [String], chargeAt: Int?, startAt: Int?, endAt: Int?, authAttempts: Int, totalCount: Int, paidCount: Int, customerNotify: Bool, createdAt: Int, expireBy: Int?, shortUrl: String, hasScheduledChanges: Bool, changeScheduledAt: Int?, source: String, remainingCount: Int) {
        self.id = id
        self.entity = entity
        self.planId = planId
        self.status = status
        self.currentStart = currentStart
        self.currentEnd = currentEnd
        self.endedAt = endedAt
        self.quantity = quantity
        self.notes = notes
        self.chargeAt = chargeAt
        self.startAt = startAt
        self.endAt = endAt
        self.authAttempts = authAttempts
        self.totalCount = totalCount
        self.paidCount = paidCount
        self.customerNotify = customerNotify
        self.createdAt = createdAt
        self.expireBy = expireBy
        self.shortUrl = shortUrl
        self.hasScheduledChanges = hasScheduledChanges
        self.changeScheduledAt = changeScheduledAt
        self.source = source
        self.remainingCount = remainingCount
    }
}
