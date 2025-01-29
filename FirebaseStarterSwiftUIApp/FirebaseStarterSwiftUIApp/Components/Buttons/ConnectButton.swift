import SwiftUI

struct ConnectButton: View {
    var isConnected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isConnected ? Color.red : Color.green)
                    .frame(width: 80, height: 80)
                
                Image(systemName: isConnected ? "xmark" : "bolt.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
        }
    }
}
