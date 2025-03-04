import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    var body: some View {
        ToolbarView(title: "Privacy Policy")
           
        WebView(url: URL(string: "https://planet-proxy.com/privacypolicy")!)
            .edgesIgnoringSafeArea(.all) // ✅ Fullscreen scaling
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
    }

}

// ✅ Preview
#Preview {
    PrivacyPolicyView()
}
