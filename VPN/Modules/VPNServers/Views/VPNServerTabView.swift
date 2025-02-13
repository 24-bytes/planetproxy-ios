import SwiftUI

struct VPNServerTabView: View {
    @Binding var selectedTab: String
    let tabs = ["Default", "Browsing", "Gaming"]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    VStack(spacing: 4) { // ✅ Adjusted spacing for balance
                        Text(NSLocalizedString(tab, comment: ""))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedTab == tab ? .white : .gray)

                        // ✅ Centered Purple Underline with Fixed Width
                        Rectangle()
                            .frame(width: 30, height: 3) // ✅ Fixed width 30 units
                            .foregroundColor(selectedTab == tab ? .customPurple : .clear)
                            .cornerRadius(1.5)
                    }
                    .frame(maxWidth: .infinity) // ✅ Ensures even spacing
                }
                .padding(.vertical, 8)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
        }
        .padding(.horizontal)
    }
}
