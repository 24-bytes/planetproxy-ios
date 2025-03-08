//
//  FreshchatView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 05/03/25.

import SwiftUI
import FreshchatSDK

struct FreshchatView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            Freshchat.sharedInstance().showConversations(uiViewController)
        }
    }
}
