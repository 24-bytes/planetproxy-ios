//
//  TimerView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 13/02/25.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var metricsManager = VPNMetricsManager.shared
    let location: String
    let ipAddress: String
    let onDisconnect: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Timer
            Text(metricsManager.formattedDuration)
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(.white)

            // IP & Location Info
            Text("\(location) | \(ipAddress)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)

            // Disconnect Button
            Button(action: { onDisconnect() }) {
                Text("Disconnect")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.customPurple)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .padding(.horizontal, 30)
        .background(Color.cardBg)
        .cornerRadius(20)
        .shadow(color: Color.gray.opacity(0.2), radius: 6)
    }
}
