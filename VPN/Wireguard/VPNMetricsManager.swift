import Foundation
import NetworkExtension

class VPNMetricsManager: ObservableObject {
    static let shared = VPNMetricsManager()
    
    @Published private(set) var connectionStartTime: Date?
    @Published private(set) var totalDataTransferred: Int64 = 0
    
    private var updateTimer: Timer?
    private let updateInterval: TimeInterval = 1.0
    private var lastUpdateTime: Date?
    
    private init() {
        setupMetricsUpdates()
    }
    
    func startTracking() {
        connectionStartTime = Date()
        lastUpdateTime = Date()
        totalDataTransferred = 0
        startMetricsUpdates()
    }
    
    func stopTracking() {
        connectionStartTime = nil
        lastUpdateTime = nil
        stopMetricsUpdates()
    }
    
    var connectionDuration: TimeInterval {
        guard let startTime = connectionStartTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    var formattedDuration: String {
        let duration = Int(connectionDuration)
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    var formattedDataReceived: String {
        return formatBytes(totalDataTransferred / 2) // Approximate split of total data
    }
    
    var formattedDataSent: String {
        return formatBytes(totalDataTransferred / 2) // Approximate split of total data
    }
    
    // MARK: - Private Methods
    
    private func setupMetricsUpdates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(vpnStatusChanged(_:)),
            name: NSNotification.Name.NEVPNStatusDidChange,
            object: nil
        )
    }
    
    private func startMetricsUpdates() {
        stopMetricsUpdates() // Stop any existing timer
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.updateMetrics()
        }
    }
    
    private func stopMetricsUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    @objc private func vpnStatusChanged(_ notification: Notification) {
        guard let connection = notification.object as? NEVPNConnection else { return }
        
        switch connection.status {
        case .connected:
            startTracking()
        case .disconnected, .invalid:
            stopTracking()
        default:
            break
        }
    }
    
    private func updateMetrics() {
        guard let lastUpdate = lastUpdateTime else { return }
        
        // Simulate data transfer based on time connected
        // This is an approximation - actual data transfer would vary based on usage
        let timeElapsed = Date().timeIntervalSince(lastUpdate)
        let averageKBPerSecond: Int64 = 50 // Average 50KB/s for demonstration
        let newData = Int64(timeElapsed * Double(averageKBPerSecond * 1024))
        
        totalDataTransferred += newData
        lastUpdateTime = Date()
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let kb = Double(bytes) / 1024
        if kb < 1024 {
            return String(format: "%.1f KB", kb)
        }
        let mb = kb / 1024
        if mb < 1024 {
            return String(format: "%.1f MB", mb)
        }
        let gb = mb / 1024
        return String(format: "%.2f GB", gb)
    }
}
