//
//  SidebarFooterView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 11/02/25.
//

import SwiftUI

struct SidebarFooterView: View {
    var body: some View {
        VStack {
            HStack {
                Image("Logo") // Replace with VPN logo
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.purple)

                Text("Planet Proxy")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Text("Version 1.2.3")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
