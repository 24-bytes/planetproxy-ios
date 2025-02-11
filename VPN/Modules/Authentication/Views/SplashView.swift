import SwiftUI

struct SplashView: View {
    @State private var isLoading = false
    @State private var scale: CGFloat = 0.1

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            Image("Logo")  // Ensure asset exists
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .opacity(isLoading ? 1 : 0)
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        isLoading = true
                        scale = 1
                    }
                }
        }
    }
}
