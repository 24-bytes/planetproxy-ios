import Foundation

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    var isExpanded: Bool = true

    static let sampleFAQs = [
        FAQItem(
            question: NSLocalizedString("faq_vpn_question", comment: "What is a VPN?"),
            answer: NSLocalizedString("faq_vpn_answer", comment: "VPN explanation")
        ),
        FAQItem(
            question: NSLocalizedString("faq_why_use_question", comment: "Why should I use Planet Proxy?"),
            answer: NSLocalizedString("faq_why_use_answer", comment: "Benefits of using Planet Proxy")
        ),
        FAQItem(
            question: NSLocalizedString("faq_create_account_question", comment: "How do I create an account with Planet Proxy?"),
            answer: NSLocalizedString("faq_create_account_answer", comment: "Steps to create an account")
        ),
        FAQItem(
            question: NSLocalizedString("faq_payment_methods_question", comment: "What payment methods do you accept?"),
            answer: NSLocalizedString("faq_payment_methods_answer", comment: "Available payment methods")
        ),
        FAQItem(
            question: NSLocalizedString("faq_trial_question", comment: "Can I try Planet Proxy for free?"),
            answer: NSLocalizedString("faq_trial_answer", comment: "Free trial availability")
        ),
        FAQItem(
            question: NSLocalizedString("faq_legal_question", comment: "Is Planet Proxy legal to use?"),
            answer: NSLocalizedString("faq_legal_answer", comment: "VPN legality")
        )
    ]
}
