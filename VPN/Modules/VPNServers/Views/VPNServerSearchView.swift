
import SwiftUI

struct VPNServerSearchView: View {
    @Binding var searchQuery: String

    var body: some View {
        TextField("Search servers", text: $searchQuery)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}
