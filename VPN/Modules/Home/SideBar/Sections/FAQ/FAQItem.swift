import Foundation // ✅ Required for UUID

// ✅ Sample FAQ Data
struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    var isExpanded: Bool = true // ✅ All Open by Default

    static let sampleFAQs = [
        FAQItem(question: "What is a VPN?",
                answer: "A VPN (Virtual Private Network) encrypts your internet connection and hides your IP address for secure browsing."),
        FAQItem(question: "Why should I use Planet Proxy?",
                answer: "Planet Proxy provides fast, secure, and private internet access, protecting you from online threats."),
        FAQItem(question: "How do I create an account with Planet Proxy?",
                answer: "To create an account, simply sign up using your email on our website or mobile app."),
        FAQItem(question: "What payment methods do you accept?",
                answer: "We accept credit/debit cards, PayPal, and cryptocurrency for secure transactions."),
        FAQItem(question: "Can I try Planet Proxy for free?",
                answer: "Yes! We offer a free trial so you can experience our service before subscribing."),
        FAQItem(question: "Is Planet Proxy legal to use?",
                answer: "Yes, VPN services are legal in most countries. However, always check local regulations.")
    ]
}
