//
//  NavBar.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 05/02/25.
//

import SwiftUI

struct NavBar: View {
    var body: some View {
        HStack {
            Image("menu_icon") // Replace with your menu icon asset
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)

            Spacer()

            Text("Planet Proxy")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            ZStack {
                Image("premium_icon") // Replace with your premium cloud image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Image("star_icon") // Replace with your small star icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .offset(x: 10, y: -10)
            }
        }
        .padding(.horizontal)
    }
}
