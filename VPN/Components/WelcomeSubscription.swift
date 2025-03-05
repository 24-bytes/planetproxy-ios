import SwiftUI

struct WelcomeSubscription: View {
    var body: some View {
        ZStack{
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
                        .foregroundColor(Color.customPurple.opacity(0.9))
                }
            }
            .padding()
            .background(Color.customPurple.opacity(0.2)) // ✅ Custom purple background
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.customPurple.opacity(0.6), lineWidth: 1) // ✅ Matching border
            )
        }
    }
}
