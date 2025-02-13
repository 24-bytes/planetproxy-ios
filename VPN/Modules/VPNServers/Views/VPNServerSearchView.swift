import SwiftUI

struct VPNServerSearchView: View {
    @Binding var searchQuery: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(NSLocalizedString("Search servers", comment: "Search Placeholder"), text: $searchQuery)
                .foregroundColor(.black)
                .textFieldStyle(PlainTextFieldStyle())

            if !searchQuery.isEmpty {
                Button(action: { searchQuery = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
