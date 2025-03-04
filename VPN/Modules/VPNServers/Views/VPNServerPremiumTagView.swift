import SwiftUI

struct VPNServerPremiumTagView: View {
    var body: some View {
        HStack(spacing: 6) {
            // ✅ Purple Circular Background for Star Icon
            ZStack {
                Circle()
                    .fill(Color.customPurple) // Background Circle
                    .frame(width: 15, height: 15)

                Image(systemName: "star.fill") // Star Icon
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
            }

            // ✅ "Premium" Text
            Text(NSLocalizedString("Premium", comment: "Premium Label"))
                .font(.system(size: 9))
                .foregroundColor(.white)
                .padding(.trailing, 3) // Extra padding for balance
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(Color.black) // Background of the tag
        .overlay(
            RoundedRectangle(cornerRadius: 20) // ✅ Purple Border
                .stroke(Color.customPurple, lineWidth: 2  )
        )
        .cornerRadius(20) // ✅ Pill-Shaped Borders
    }
}
