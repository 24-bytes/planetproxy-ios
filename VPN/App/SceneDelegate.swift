import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        
        let splashView = UIHostingController(rootView: SplashView().onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let contentView = UIHostingController(rootView: ContentView().environmentObject(AuthViewModel()))
                self.window?.rootViewController = contentView
                self.window?.makeKeyAndVisible()
            }
        })

        window.rootViewController = splashView
        self.window = window
        window.makeKeyAndVisible()
    }
}
