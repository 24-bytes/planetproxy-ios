import SwiftUI

struct MetricsView: View {
    @StateObject private var metricsManager = VPNMetricsManager.shared
    
    var body: some View {
        HStack {
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                                     Text(LocalizedStringKey("download"))
                                         .font(.system(size: 14, weight: .medium))
                                         .foregroundColor(.gray)

                                     Image("download_arrow") // Placeholder for downward arrow image
                                         .resizable()
                                         .frame(width: 16, height: 16)
                                 }
                Text(metricsManager.formattedDataReceived)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            Rectangle()
                .frame(width: 1, height: 40)
                .foregroundColor(Color.gray.opacity(0.5))
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                                     Text(LocalizedStringKey("upload"))
                                         .font(.system(size: 14, weight: .medium))
                                         .foregroundColor(.gray)

                                     Image("upload_arrow") // Placeholder for downward arrow image
                                         .resizable()
                                         .frame(width: 16, height: 16)
                                 }
                Text(metricsManager.formattedDataSent)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .cornerRadius(16)
        .shadow(color: Color.gray.opacity(0.2), radius: 4)
    }
}
