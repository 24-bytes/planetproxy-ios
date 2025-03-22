//
//  BannerAdView.swift
//  VPN
//
//  Created by Siddhant Kundlik Thaware on 11/03/25.
//

import SwiftUI
import GoogleMobileAds
import UIKit

struct BannerAdView: UIViewControllerRepresentable {
    let adUnitID: String

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let adView = GADBannerView(adSize: GADAdSizeBanner)
        adView.adUnitID = adUnitID
        adView.rootViewController = viewController
        adView.load(GADRequest())
        
        viewController.view.addSubview(adView)
        
        // Auto Layout for ad placement
        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            adView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
