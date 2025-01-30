import SwiftUI

struct FAQView: View {
    struct FAQItem: Identifiable {
        let id = UUID()
        let question: String
        let answer: String
        var isExpanded: Bool = false
    }
    
    @State private var faqItems = [
        FAQItem(question: "What is a VPN?", 
               answer: "A VPN (Virtual Private Network) is a service that encrypts your internet traffic and hides your IP address, providing secure and private online browsing."),
        FAQItem(question: "Why should I use Planet Proxy?",
               answer: "Planet Proxy offers fast servers, strong encryption, and a user-friendly interface, all at an affordable price."),
        FAQItem(question: "What payment methods do you accept?",
               answer: "We accept major credit cards, PayPal, and various other payment methods.")
    ]
    
    var body: some View {
        List {
            ForEach($faqItems) { $item in
                VStack(alignment: .leading) {
                    Button(action: { item.isExpanded.toggle() }) {
                        Text(item.question)
                            .fontWeight(.semibold)
                    }
                    
                    if item.isExpanded {
                        Text(item.answer)
                            .padding(.top, 5)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("FAQ")
    }
}
