import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    var body: some View {
        WebView(url: URL(string: "https://planet-proxy.com/privacypolicy")!)
            .edgesIgnoringSafeArea(.all) // ✅ Fullscreen scaling
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// ✅ Preview
#Preview {
    PrivacyPolicyView()
}
