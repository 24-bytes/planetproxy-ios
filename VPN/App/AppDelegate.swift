import Firebase
import FirebaseCore
import GoogleSignIn
import UIKit
import FreshchatSDK

@main
final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        let freshchatConfig = FreshchatConfig(appID: "21545ce2-8c4b-4d87-9eb9-785165cd79e0", andAppKey: "4820a0a1-2703-4801-b6ab-0c8b4a42af9b")
            freshchatConfig.domain = "https://msdk.in.freshchat.com/"
            
            // Enable or disable features
            freshchatConfig.gallerySelectionEnabled = true
            freshchatConfig.cameraCaptureEnabled = true
            freshchatConfig.teamMemberInfoVisible = true
            freshchatConfig.showNotificationBanner = true

            Freshchat.sharedInstance().initWith(freshchatConfig)

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {

        print(url)

        var handled = GIDSignIn.sharedInstance.handle(url)
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
