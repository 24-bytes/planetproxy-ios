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

                Text(LocalizedStringKey("app_title"))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Text(LocalizedStringKey("vpn_version"))
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
