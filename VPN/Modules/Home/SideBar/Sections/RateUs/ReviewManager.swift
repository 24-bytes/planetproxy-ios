//
//  ReviewManager.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 11/03/25.
//

import Foundation
import StoreKit
import UIKit

class ReviewManager {
    static let shared = ReviewManager()

    private let lastReviewDateKey = "lastReviewDate"
    private let hasReviewedKey = "hasReviewed"

    private init() {}

    /// Check if the review prompt should be shown and request it.
    func requestReviewIfNeeded() {
        guard !hasUserReviewed(), isFirstConnectionToday() else { return }
        requestAppStoreReview()
    }

    /// Request App Store review
    private func requestAppStoreReview() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                self.markReviewPrompted()
            }
        }
    }

    /// Check if the review prompt was already shown today
    private func isFirstConnectionToday() -> Bool {
        let lastDate = UserDefaults.standard.object(forKey: lastReviewDateKey) as? Date ?? .distantPast
        let calendar = Calendar.current
        return !calendar.isDateInToday(lastDate)
    }

    /// Check if the user has already reviewed
    private func hasUserReviewed() -> Bool {
        return UserDefaults.standard.bool(forKey: hasReviewedKey)
    }

    /// Mark that the review prompt was shown
    private func markReviewPrompted() {
        UserDefaults.standard.set(Date(), forKey: lastReviewDateKey)
    }

    /// Mark that the user has submitted a review
    func markUserReviewed() {
        UserDefaults.standard.set(true, forKey: hasReviewedKey)
    }
}
