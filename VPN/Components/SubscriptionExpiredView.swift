import SwiftUI

struct SubscriptionExpiredView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Subscription Has Expired!")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)

            Text("Your premium access has ended. Renew your subscription to regain unlimited features.")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            Button(action: {
                print("Reactivate Subscription")
            }) {
                Text("Reactivate Now")
                    .foregroundColor(.purple)
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBg)
                .shadow(color: Color.gray.opacity(0.15), radius: 5, x: 0, y: 2)
        )
    }
}
