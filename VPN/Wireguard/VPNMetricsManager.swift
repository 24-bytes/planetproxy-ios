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
        stopMonitoring() // Ensure no duplicate timers
        tunnelSession = session
        
        if connectionStartTime == nil {
            connectionStartTime = Date()
            saveConnectionStartTime()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.fetchUsageMetrics()
            self?.updateConnectionDuration()
        }
    }
    
    func resumeMonitoring() {
        if timer == nil, let session = tunnelSession {
            startMonitoring(session: session)
        }
    }
    
    func refreshMetrics() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.fetchUsageMetrics()
            self?.updateConnectionDuration()
            self?.resumeMonitoring()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        tunnelSession = nil
        previousTxBytes = 0
        previousRxBytes = 0
        saveMetrics()
    }
    
    private func fetchUsageMetrics() {
        guard let session = tunnelSession else {
            print("❌ Error: No active tunnel session")
            return
        }
        
        do {
            try session.sendProviderMessage(Data(), responseHandler: { [weak self] response in
                guard let self = self else { return }
                
                print("📊 Received response size: \(response?.count ?? 0) bytes")
                
                guard let response = response, response.count >= MemoryLayout<UInt64>.size * 2 else {
                    print("❌ Error: Invalid response from provider message. Response: \(String(describing: response))")
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
            connectionDuration = Date().timeIntervalSince(startTime)
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
    
    private func loadSavedMetrics() {
        if let savedMetrics = UserDefaults.standard.dictionary(forKey: "VPNMetrics") {
            dataSent = savedMetrics["dataSent"] as? UInt64 ?? 0
            dataReceived = savedMetrics["dataReceived"] as? UInt64 ?? 0
            connectionDuration = savedMetrics["connectionDuration"] as? TimeInterval ?? 0
            connectionStartTime = savedMetrics["connectionStartTime"] as? Date ?? Date()
        }

        // Load VPN session and check connection status
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            guard let manager = managers?.first else {
                print("❌ No VPN configurations found")
                return
            }
            self.tunnelSession = manager.connection as? NETunnelProviderSession
            
            if manager.connection.status == .connected {
                print("✅ VPN is still connected, resuming metrics tracking")
                self.resumeMonitoring()
            }
        }
    }

    
    private func saveConnectionStartTime() {
        UserDefaults.standard.set(connectionStartTime, forKey: "connectionStartTime")
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
    
    private func setupVPNStatusObserver() {
        NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.handleVPNStatusChange()
            }
        }
    }

    private func handleVPNStatusChange() {
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            guard let manager = managers?.first else { return }
            self.tunnelSession = manager.connection as? NETunnelProviderSession
            
            if manager.connection.status == .connected {
                print("🔄 VPN Reconnected: Restarting Metrics Monitoring")
                self.startMonitoring(session: self.tunnelSession!)
            } else {
                print("🚫 VPN Disconnected: Stopping Metrics Monitoring")
                self.stopMonitoring()
            }
        }
    }

}


