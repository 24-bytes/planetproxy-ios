import SwiftUI

struct VPNServerTabView: View {
    @Binding var selectedTab: String
    let tabs: [String]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    VStack(spacing: 4) {
                        Text(NSLocalizedString("tab", comment: "tab"))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedTab == tab ? .white : .gray)

                        Rectangle()
                            .frame(width: 30, height: 3)
                            .foregroundColor(selectedTab == tab ? .purple : .clear)
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

