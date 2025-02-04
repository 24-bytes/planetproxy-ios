import SwiftUI
import Firebase
import GoogleSignIn

struct VPNApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authViewModel = AuthViewModel()
    
    @StateObject private var navigation = NavigationCoordinator()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(navigation)
      }
    }
}
