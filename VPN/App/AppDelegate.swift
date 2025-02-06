import UIKit
import Firebase
import FirebaseCore
import GoogleSignIn

@main
final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        // Configure Facebook SDK
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    func application(_ app: UIApplication,
                    open url: URL,
                    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        // Handle Google Sign In callback URL
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }

        // Handle Facebook Sign In callback URL
//        if ApplicationDelegate.shared.application(app, open: url, options: options) {
//            return true
//        }

        return false
    }

    func application(_ application: UIApplication,
                    configurationForConnecting connectingSceneSession: UISceneSession,
                    options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
