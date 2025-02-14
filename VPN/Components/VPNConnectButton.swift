import SwiftUI

struct VPNConnectButton: View {
    @Binding var isConnected: Bool

    var body: some View {
        ZStack {
            // ✅ Background Glow Gradient
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.4),
                    Color.black.opacity(0.8)
                ]),
                center: .center,
                startRadius: 10,
                endRadius: 200 // ✅ Soft spread for glow
            )
            .ignoresSafeArea()

            // ✅ Outer Glow Layer
            RoundedRectangle(cornerRadius: 45)
                .fill(Color.green.opacity(0.2))
                .frame(width: 220, height: 220)
                .blur(radius: 40) // ✅ Smooth Glow Effect
            

            // ✅ Inner Green Button
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.connectButton) // ✅ Light green exact shade
                .frame(width: 150, height: 150)
                .overlay(
                    Image("thunderbolt") // ✅ Thunderbolt Icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black) // ✅ Icon in center
                )
            
            // ✅ Outer Border
            RoundedRectangle(cornerRadius: 35)
                .stroke(Color.white, lineWidth: 4)
                .frame(width: 140, height: 140)
                .shadow(color: Color.green.opacity(0.7), radius: 20) // ✅ Soft Shadow Effect
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isConnected.toggle()
            }
        }
    }
}

// ✅ Live Preview
struct VPNConnectButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VPNConnectButton(isConnected: .constant(false))
        }
    }
}
