//
//  MetricsView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 05/02/25.
//

import SwiftUI

struct MetricsView: View {
    @StateObject private var metricsManager = VPNMetricsManager.shared
    
    var body: some View {
        HStack {
            // Download Section
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Text("Download")
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

            // Vertical Divider (Grey Line)
            Rectangle()
                .frame(width: 1, height: 40)
                .foregroundColor(Color.gray.opacity(0.5))

            // Upload Section
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                Text("Upload")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    
                    Image("upload_arrow") // Placeholder for upward arrow image
                        .resizable()
                        .frame(width: 16, height: 16)
                }

                Text(metricsManager.formattedDataSent)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .padding() // Matched to Figma UI
        .cornerRadius(16) // More rounded corners
        .shadow(color: Color.gray.opacity(0.2), radius: 4)
    }
}
