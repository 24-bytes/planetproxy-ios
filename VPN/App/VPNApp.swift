import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseCore

struct VPNApp: App {
    
    init() {
        FirebaseApp.configure()
    }

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var sidebarViewModel = SidebarViewModel()
    @StateObject private var navigation = NavigationCoordinator()

    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @State private var isSplashScreenShown = true

    var body: some Scene {
        WindowGroup {
            if isSplashScreenShown {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isSplashScreenShown = false
                                hasLaunchedBefore = true
                            }
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(navigation)
                    .environmentObject(sidebarViewModel)
                    .preferredColorScheme(.dark)
                    .onAppear {
                        authViewModel.loadAuthState()
                    }
            }
        }
    }
}
