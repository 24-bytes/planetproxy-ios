import SwiftUI

struct SubscriptionExpiredView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // ✅ Title
            Text("Your Subscription Has Expired!")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            // ✅ Description
            Text("Your premium access has ended. Renew your subscription to regain unlimited features.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)

            // ✅ Reactivate Button
            Button(action: {
                print("Reactivate Subscription Clicked") // ✅ Implement navigation action
            }) {
                Text("Reactivate Now")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.customPurple.opacity(0.9))
            }
        }
        .padding()
        .background(Color.customPurple.opacity(0.2)) // ✅ Matching purple background
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.customPurple.opacity(0.6), lineWidth: 1) // ✅ Subtle purple border
        )
    }
}
