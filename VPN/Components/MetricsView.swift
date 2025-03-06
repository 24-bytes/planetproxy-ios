import SwiftUI

struct MetricsView: View {
    @StateObject private var metricsManager = VPNMetricsManager.shared
    
    var body: some View {
        HStack {
            VStack(spacing: 8) {
                Text("Download")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Text(metricsManager.formattedDataReceived)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                metricsManager.refreshMetrics()
            }
            Rectangle()
                .frame(width: 1, height: 40)
                .foregroundColor(Color.gray.opacity(0.5))
            VStack(spacing: 8) {
                Text("Upload")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Text(metricsManager.formattedDataSent)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                metricsManager.refreshMetrics()
            }
        }
        .padding()
        .cornerRadius(16)
        .shadow(color: Color.gray.opacity(0.2), radius: 4)
    }
}
