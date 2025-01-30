import SwiftUI

struct ServerCard: View {
    let server: VPNServer
    var isConnected: Bool
    var onConnect: () -> Void
    
    var body: some View {
        HStack {
            // Country flag and info
            HStack {
                Text(server.flag)
                    .font(.title)
                
                VStack(alignment: .leading) {
                    Text(server.country)
                        .font(.headline)
                    Text(server.city)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Ping and connect button
            HStack {
                Text("\(server.pingTime) ms")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Button(action: onConnect) {
                    Text(isConnected ? "Connected" : "Connect")
                        .foregroundColor(isConnected ? .green : .purple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isConnected ? Color.green : Color.purple)
                        )
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
