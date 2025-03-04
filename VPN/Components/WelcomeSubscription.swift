//
//  WelcomeSubscription.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 14/02/25.
//

import SwiftUI

struct WelcomeSubscription: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // ✅ Title
            Text("You are part of a free premium subscription for up to 90 days")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            // ✅ Description
            Text("Unlock all features with a premium subscription. Enjoy faster speeds, unlimited data, and priority servers. No credit card required.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)

            // ✅ Join Now Button
            Button(action: {
                print("Join Now Clicked") // ✅ Implement navigation action
            }) {
                Text("Join Now")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.purple.opacity(0.9))
            }
        }
        .padding()
        .background(Color(red: 0.18, green: 0.18, blue: 0.3)) // ✅ Purple background
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.purple.opacity(0.6), lineWidth: 1) // ✅ Border
        )
        .padding(.horizontal)
    }
}

// ✅ Preview
struct PremiumSubscriptionCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // ✅ Background color to match UI
            WelcomeSubscription()
        }
    }
}
