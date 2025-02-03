
import SwiftUI

struct SplashView: View {

    @State private var isLoading = false

    @State private var scale = 0.1

    var body: some View {
        ZStack {
            Color("Primary")
                .edgesIgnoringSafeArea(.all)

            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .opacity(isLoading ? 1 : 0)
                .scaleEffect(scale)
                .animation(.easeInOut(duration: 1.5))
                .onAppear {
                    withAnimation {
                        self.isLoading = true
                        self.scale = 1
                    }
                }
        }
    }
}
