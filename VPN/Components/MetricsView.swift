//
//  MetricsView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 05/02/25.
//

import SwiftUI

struct MetricsView: View {
    var downloadSpeed: Double
    var uploadSpeed: Double

    var body: some View {
        HStack {
            VStack {
                Text("Download")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text("\(String(format: "%.1f", downloadSpeed)) MB")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            VStack {
                Text("Upload")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text("\(String(format: "%.1f", uploadSpeed)) MB")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 5)
        .padding(.horizontal)
    }
}
