//
//  DisconnectConfirmationView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 14/02/25.
//

import SwiftUI

struct DisconnectConfirmationView: View {
    @Binding var isPresented: Bool
    let onDisconnectConfirmed: () -> Void

    var body: some View {
        ZStack {
            // ✅ Dim Background
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { isPresented = false }

            VStack(spacing: 16) {
                Text("Are You Sure You Want to Disconnect?")
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                Text("Disconnecting will end your secure connection. Your online activity may be exposed.")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)

                // ✅ Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        onDisconnectConfirmed()
                        isPresented = false
                    }) {
                        Text("Disconnect Anyway")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "#6B50FF")) // Light purple
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#E4D9FF")) // Soft purple background
                            .cornerRadius(10)
                    }

                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Stay Connected")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#6B50FF")) // Dark purple
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
        }
    }
}
