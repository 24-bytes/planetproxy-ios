//
//  SubscriptionView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 14/02/25.
//

import SwiftUI

struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ToolbarView(title: "Subscription")

            // ✅ Header Text
            Text("Current plan")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            Text("Your next payment is scheduled for November 8, 2024.\nStay subscribed to continue enjoying premium features.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineSpacing(4)

            // ✅ Plan Card
            planCard

            Spacer()

            // ✅ Buttons
           // actionButtons
        }.navigationBarBackButtonHidden(true)
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all)) // ✅ Background color
    }

    // ✅ Subscription Plan Card
    private var planCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack  {
                Image("gold_plan_icon") // ✅ Replace with Gold Plan Image
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("Gold plan")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Text("$10/mth")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.purple)
            }

            Text("Secure up to 10 users with 20GB individual data, perfect for personal use. Enjoy fast servers and top-notch encryption at an affordable price.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineSpacing(4)

            Divider().background(Color.gray.opacity(0.5))

            VStack(alignment: .leading, spacing: 8) {
                planFeature("Access to all basic features")
                planFeature("Basic reporting and analytics")
                planFeature("Up to 10 individual users")
                planFeature("20GB individual data each user")
                planFeature("Basic chat and email support")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.15))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.purple.opacity(0.8), lineWidth: 1)) // ✅ Border matching design
    }

    // ✅ Feature List Item
    private func planFeature(_ text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 16))

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
    }

    // ✅ Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { print("Cancel Subscription") }) {
                Text("Cancel subscription")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }

            Button(action: { print("Upgrade Subscription") }) {
                Text("Upgrade subscription")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(8)
            }
        }
    }
}
