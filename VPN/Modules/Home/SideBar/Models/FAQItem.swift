import Foundation

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    var isExpanded: Bool = false
    
    static let sampleFAQs = [
        FAQItem(question: "What is PlanetProxy?", 
                answer: "PlanetProxy is a secure VPN service that helps protect your online privacy and security."),
        FAQItem(question: "How do I connect to a VPN server?", 
                answer: "Simply select your desired server location and click the connect button. The app will handle the rest."),
        FAQItem(question: "Is my data secure?", 
                answer: "Yes, we use military-grade encryption to protect your data and maintain a strict no-logs policy."),
        FAQItem(question: "What protocols do you support?", 
                answer: "We support multiple VPN protocols including UDP and TCP for maximum compatibility and security.")
    ]
}
