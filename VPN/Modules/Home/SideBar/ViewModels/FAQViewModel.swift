import SwiftUI

class FAQViewModel: ObservableObject {
    @Published var faqItems: [FAQItem] = FAQItem.sampleFAQs
    @Published var searchText = ""
    
    var filteredFAQs: [FAQItem] {
        if searchText.isEmpty {
            return faqItems
        }
        return faqItems.filter { item in
            item.question.localizedCaseInsensitiveContains(searchText) ||
            item.answer.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func toggleItem(_ item: FAQItem) {
        if let index = faqItems.firstIndex(where: { $0.id == item.id }) {
            faqItems[index].isExpanded.toggle()
        }
    }
}
