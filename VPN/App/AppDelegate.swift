import Firebase
import FirebaseCore
import GoogleSignIn
import UIKit
import FreshchatSDK
import GoogleMobileAds
import Mixpanel

@main
final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [
                    "ccc7c92f66f81614e4b2d38e21690713" // Replace with your test device ID
                ]
        AdsManager.shared.loadAd()
        
        let freshchatConfig = FreshchatConfig(appID: "21545ce2-8c4b-4d87-9eb9-785165cd79e0", andAppKey: "4820a0a1-2703-4801-b6ab-0c8b4a42af9b")
            freshchatConfig.domain = "msdk.in.freshchat.com"
            
            // Enable or disable features
            freshchatConfig.gallerySelectionEnabled = true
            freshchatConfig.cameraCaptureEnabled = true
            freshchatConfig.teamMemberInfoVisible = true
            freshchatConfig.themeName = "FreshchatTheme"
            freshchatConfig.showNotificationBanner = true

            Freshchat.sharedInstance().initWith(freshchatConfig)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        Mixpanel.initialize(token: "YOUR_PROJECT_TOKEN",
                trackAutomaticEvents: false
                )

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {

        print(url)

        let handled = GIDSignIn.sharedInstance.handle(url)
        return handled

    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        let sceneConfig = UISceneConfiguration(
            name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Freshchat.sharedInstance().setPushRegistrationToken(deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Freshchat.sharedInstance().isFreshchatNotification(userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(userInfo, andAppstate: application.applicationState)
        }
    }

}
