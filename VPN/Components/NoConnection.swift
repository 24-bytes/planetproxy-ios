import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = false  // Initially false to avoid flashing
    @Published var isInitialized: Bool = false // Track if network status is received

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isInitialized = true // Network status is now known
            }
        }
        monitor.start(queue: queue)
    }
}

struct NoInternetView: View {
    @ObservedObject var networkMonitor = NetworkMonitor.shared

    var body: some View {
        if networkMonitor.isInitialized && !networkMonitor.isConnected {
            VStack(spacing: 20) {
                Image("noconnection")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text("No Internet Connection")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Button(action: {
                    self.checkConnection()
                }) {
                    Text("Retry")
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.darkGray), lineWidth: 2)
                        )
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
    
    private func checkConnection() {
        networkMonitor.isConnected = NWPathMonitor().currentPath.status == .satisfied
    }
}
