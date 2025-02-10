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
       
      @StateObject private var navigation = NavigationCoordinator()


      var body: some Scene {
        WindowGroup {
          ContentView()
            .environmentObject(authViewModel)
            .environmentObject(navigation)
            .preferredColorScheme(.dark)
            .onAppear {
                authViewModel.loadAuthState() // ✅ Load auth state at startup
            }
       }
      }
    }
