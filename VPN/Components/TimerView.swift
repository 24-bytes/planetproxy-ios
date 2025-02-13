//
//  TimerView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 13/02/25.
//

import SwiftUI

struct TimerView: View {
    @State private var elapsedTime: Int = 225 // Static time (3 min 45 sec)
    let navigation: NavigationCoordinator
    let location: String
    let ipAddress: String

    var body: some View {
        VStack(spacing: 16) {
            // Timer
            Text(formattedTime(elapsedTime))
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(.white)

            // IP & Location Info
            Text("\(location) | \(ipAddress)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)

            // Change Server Button
            Button(action: { navigation.navigateToServers() }) {
                Text("Change server")
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
        .padding(.horizontal)
        .onAppear {
            startTimer()
        }
    }

    // Format elapsed time into HH:MM:SS format
    private func formattedTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Timer function to increment time
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            elapsedTime += 1
        }
    }
}
