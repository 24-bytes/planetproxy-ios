import SwiftUI

struct FAQView: View {
    @StateObject private var viewModel = FAQViewModel()
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
            
            List(viewModel.filteredFAQs) { item in
                FAQItemView(item: item) {
                    viewModel.toggleItem(item)
                }
            }
        }
        .navigationTitle("FAQ")
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search FAQ", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}

struct FAQItemView: View {
    let item: FAQItem
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: action) {
                HStack {
                    Text(item.question)
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: item.isExpanded ? "chevron.up" : "chevron.down")
                }
            }
            
            if item.isExpanded {
                Text(item.answer)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FAQView()
}
