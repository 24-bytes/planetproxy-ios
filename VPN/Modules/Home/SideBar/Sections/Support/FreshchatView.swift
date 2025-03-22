import SwiftUI
import FreshchatSDK

struct FreshchatView: UIViewControllerRepresentable {
    let onDismiss: () -> Void  // Callback to handle dismissal

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            Freshchat.sharedInstance().showConversations(viewController)
            context.coordinator.parentViewController = viewController
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, onDismiss: onDismiss)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate {
        var parent: FreshchatView
        var onDismiss: () -> Void
        weak var parentViewController: UIViewController?

        init(_ parent: FreshchatView, onDismiss: @escaping () -> Void) {
            self.parent = parent
            self.onDismiss = onDismiss
        }

        func checkIfDismissed() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.parentViewController?.presentedViewController == nil {
                    self.onDismiss()
                } else {
                    self.checkIfDismissed()
                }
            }
        }
    }
}
