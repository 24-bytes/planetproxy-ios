
import SwiftUI

struct VPNServerTabView: View {
    @Binding var selectedTab: String
    let tabs = ["Default", "Streaming", "Gaming"]

    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    Text(tab)
                        .foregroundColor(selectedTab == tab ? .white : .gray)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(selectedTab == tab ? Color.purple : Color.clear)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}
