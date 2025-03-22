import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    @Published var isDataConnected: Bool = true
    @Published var isInitialized: Bool = false
    
    private var lastPathStatus: NWPath.Status = .satisfied
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // 🔄 Increased delay
                let isConnected = path.status == .satisfied

                if !isConnected {
                    // Double-check network reachability before setting to false
                    DispatchQueue.global(qos: .background).async {
                        let testConnection = NWPathMonitor().currentPath.status == .satisfied
                        DispatchQueue.main.async {
                            self.isDataConnected = testConnection
                        }
                    }
                } else {
                    self.isDataConnected = true
                }

                self.isInitialized = true
                self.lastPathStatus = path.status
            }
        }
        monitor.start(queue: queue)
    }
    
    func refreshStatus() {
        let path = monitor.currentPath
        DispatchQueue.main.async {
            self.isDataConnected = path.status == .satisfied
        }
    }
}


struct NoInternetView: View {
    @ObservedObject var networkMonitor = NetworkMonitor.shared

    var body: some View {
        if networkMonitor.isInitialized && !networkMonitor.isDataConnected {
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
        networkMonitor.refreshStatus()
       }
}
