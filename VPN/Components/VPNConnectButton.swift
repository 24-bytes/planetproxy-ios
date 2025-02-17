import SwiftUI

struct VPNConnectButton: View {
    @StateObject private var viewModel = VPNConnectionViewModel()
        
        var body: some View {
            VStack(spacing: 20) {
                statusView
                
                Button(action: {
                    viewModel.toggleConnection()
                }) {
                    if viewModel.isConnecting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text(viewModel.connectionStatus == .connected ? "Disconnect" : "Connect")
                            .font(.headline)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isConnecting)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .padding()
        }
        
        private var statusView: some View {
            HStack {
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                Text(viewModel.connectionStatus.description)
                    .font(.subheadline)
            }
        }
        
        private var statusColor: Color {
            switch viewModel.connectionStatus {
            case .connected:
                return .green
            case .connecting, .disconnecting:
                return .orange
            case .disconnected:
                return .red
            case .failed:
                return .red
            }
        }
}
