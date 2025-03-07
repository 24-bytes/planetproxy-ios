import Foundation
import NetworkExtension
import Combine

class VPNMetricsManager: ObservableObject {
    static let shared = VPNMetricsManager()
    
    @Published private(set) var dataSent: UInt64 = 0
    @Published private(set) var dataReceived: UInt64 = 0
    @Published private(set) var connectionDuration: TimeInterval = 0
    
    private var timer: Timer?
    private var previousTxBytes: UInt64 = 0
    private var previousRxBytes: UInt64 = 0
    private var tunnelSession: NETunnelProviderSession?
    private var connectionStartTime: Date?
    
    private init() {
        loadSavedMetrics()
    }
    
    func startMonitoring(session: NETunnelProviderSession) {
        timer?.invalidate()
        timer = nil
        
        tunnelSession = session
        
        // Set initial connection time if not already set
        if connectionStartTime == nil {
            if let savedMetrics = UserDefaults.standard.dictionary(forKey: "VPNMetrics"),
               let savedStartTime = savedMetrics["connectionStartTime"] as? Date {
                connectionStartTime = savedStartTime
                connectionDuration = Date().timeIntervalSince(savedStartTime)
            } else {
                connectionStartTime = Date()
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.fetchUsageMetrics()
            self?.updateConnectionDuration()
        }
        
        // Initial update
        fetchUsageMetrics()
        updateConnectionDuration()
    }

    private func loadSavedMetrics() {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            guard let self = self,
                  let manager = managers?.first else {
                return
            }
            
            self.tunnelSession = manager.connection as? NETunnelProviderSession
            
            if manager.connection.status == .connected {
                if let savedMetrics = UserDefaults.standard.dictionary(forKey: "VPNMetrics") {
                    DispatchQueue.main.async {
                        self.dataSent = savedMetrics["dataSent"] as? UInt64 ?? 0
                        self.dataReceived = savedMetrics["dataReceived"] as? UInt64 ?? 0
                        if let savedStartTime = savedMetrics["connectionStartTime"] as? Date {
                            self.connectionStartTime = savedStartTime
                            self.connectionDuration = Date().timeIntervalSince(savedStartTime)
                        }
                        
                        if let session = self.tunnelSession {
                            self.startMonitoring(session: session)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.connectionStartTime = Date()
                        if let session = self.tunnelSession {
                            self.startMonitoring(session: session)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.resetMetrics()
                }
            }
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        tunnelSession = nil
        previousTxBytes = 0
        previousRxBytes = 0
        connectionStartTime = nil
        connectionDuration = 0
        resetMetrics()
        UserDefaults.standard.removeObject(forKey: "VPNMetrics")
    }
    
    func resetMetrics() {
        dataSent = 0
        dataReceived = 0
        connectionDuration = 0
        previousTxBytes = 0
        previousRxBytes = 0
        saveMetrics()
    }

    func refreshMetrics() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.fetchUsageMetrics()
            self?.updateConnectionDuration()
            self?.resumeMonitoring()
        }
    }
    
    func resumeMonitoring() {
        if timer == nil, let session = tunnelSession {
            startMonitoring(session: session)
        }
    }
    
    private func fetchUsageMetrics() {
        guard let session = tunnelSession else {
            print("❌ Error: No active tunnel session")
            return
        }
        
        do {
            try session.sendProviderMessage(Data(), responseHandler: { [weak self] response in
                guard let self = self else { return }

                guard let response = response, response.count >= MemoryLayout<UInt64>.size * 2 else {
                    print("❌ Error: Invalid response from provider message.")
                    return
                }
                
                let txBytes = response.withUnsafeBytes { $0.load(fromByteOffset: 0, as: UInt64.self) }
                let rxBytes = response.withUnsafeBytes { $0.load(fromByteOffset: MemoryLayout<UInt64>.size, as: UInt64.self) }
                
                DispatchQueue.main.async {
                    if txBytes >= self.previousTxBytes && rxBytes >= self.previousRxBytes {
                        self.dataSent += (txBytes - self.previousTxBytes)
                        self.dataReceived += (rxBytes - self.previousRxBytes)
                    }
                    
                    self.previousTxBytes = txBytes
                    self.previousRxBytes = rxBytes
                    self.saveMetrics()
                }
            })
        } catch {
            print("❌ Failed to fetch VPN usage stats: \(error.localizedDescription)")
        }
    }
    
    private func updateConnectionDuration() {
        if let startTime = connectionStartTime {
            connectionDuration = Date().timeIntervalSince(startTime) // ✅ Only counts while VPN is connected
            saveMetrics()
        }
    }
    
    private func saveMetrics() {
        let metrics: [String: Any] = [
            "dataSent": dataSent,
            "dataReceived": dataReceived,
            "connectionDuration": connectionDuration,
            "connectionStartTime": connectionStartTime ?? Date()
        ]
        UserDefaults.standard.set(metrics, forKey: "VPNMetrics")
    }
    
    var formattedDataSent: String {
        ByteCountFormatter.string(fromByteCount: Int64(dataSent), countStyle: .binary)
    }
    
    var formattedDataReceived: String {
        ByteCountFormatter.string(fromByteCount: Int64(dataReceived), countStyle: .binary)
    }
    
    var formattedDuration: String {
        let hours = Int(connectionDuration) / 3600
        let minutes = (Int(connectionDuration) % 3600) / 60
        let seconds = Int(connectionDuration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
