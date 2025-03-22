import GoogleMobileAds

class AdsManager: NSObject {
    static let shared = AdsManager()
    private var interstitial: GADInterstitialAd?

    func loadAd() {
        let adUnitID = "ca-app-pub-3940256099942544/4411468910" // Replace with actual Ad Unit ID
        let request = GADRequest()

        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            print("Interstitial Ad Loaded Successfully")
        }
    }

    func showAd(from viewController: UIViewController) {
        guard let interstitial = interstitial else {
            print("Ad not ready yet. Loading a new one...")
            loadAd() // Try to load again
            return
        }

        interstitial.present(fromRootViewController: viewController)
        self.interstitial = nil // Reset after showing
        loadAd() // Preload next ad
    }
}
