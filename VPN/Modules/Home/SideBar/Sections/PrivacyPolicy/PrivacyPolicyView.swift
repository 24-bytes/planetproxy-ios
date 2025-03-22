import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    let navigation: NavigationCoordinator
    
    var body: some View {
        ToolbarView(title: "Privacy Policy", navigation: navigation)
           
        WebView(url: URL(string: "https://planet-proxy.com/privacypolicy")!)
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
    }

}
