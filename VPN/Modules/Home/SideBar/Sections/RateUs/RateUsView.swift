import SwiftUI
import StoreKit

struct RateUsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Color.black
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                requestAppStoreReview()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    dismiss() // Navigate back after showing the popup
                }
            }
    }
    
    private func requestAppStoreReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            AppStore.requestReview(in: windowScene)
        }
    }
}
