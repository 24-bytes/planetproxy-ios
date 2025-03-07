import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let authViewModel = AuthViewModel()
        let sidebarViewModel = SidebarViewModel()
        let navigation = NavigationCoordinator()

        let splashView = UIHostingController(rootView: SplashView().onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                DispatchQueue.main.async { // Ensure UI updates on main thread
                    let contentView = UIHostingController(
                        rootView: ContentView()
                            .environmentObject(authViewModel)
                            .environmentObject(navigation)
                            .environmentObject(sidebarViewModel)
                    )
                    self.window?.rootViewController = contentView
                    self.window?.makeKeyAndVisible()
                }
            }
        })

        window.rootViewController = splashView
        self.window = window
        window.makeKeyAndVisible()
    }
}
