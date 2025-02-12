import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Last Updated: February 12, 2025")
                        .foregroundColor(.secondary)
                    
                    PolicySection(title: "Information We Collect",
                                content: "We collect minimal information necessary to provide our VPN service. This includes your email address and basic account information. We do NOT collect or store your browsing history, DNS queries, or any other usage data.")
                    
                    PolicySection(title: "How We Use Your Information",
                                content: "Your information is used solely for account management, service provision, and communication about your subscription. We will never sell or share your personal data with third parties.")
                    
                    PolicySection(title: "Data Security",
                                content: "We employ industry-standard encryption and security measures to protect your data. Our VPN service uses military-grade encryption to ensure your online activities remain private and secure.")
                    
                    PolicySection(title: "No-Logs Policy",
                                content: "PlanetProxy maintains a strict no-logs policy. We do not track, collect, or store any information about your online activities while using our VPN service.")
                }
                
                Group {
                    PolicySection(title: "Your Rights",
                                content: "You have the right to access, modify, or delete your personal information at any time. Contact our support team to exercise these rights.")
                    
                    PolicySection(title: "Changes to Policy",
                                content: "We may update this privacy policy periodically. We will notify you of any material changes via email or through our application.")
                    
                    PolicySection(title: "Contact Us",
                                content: "If you have any questions about our privacy policy, please contact us at privacy@planetproxy.com")
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
