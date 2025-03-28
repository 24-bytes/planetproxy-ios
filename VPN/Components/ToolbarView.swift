import SwiftUI

struct ToolbarView: View {
    let title: String
    @Environment(\.presentationMode) var presentationMode
    let navigation: NavigationCoordinator

    var body: some View {
        HStack {
            // ✅ Back Button
            Button(action: {
                navigateBack()
            }){
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.2)) // ✅ Circle behind back arrow
                    )
            }
            .frame(width: 44, height: 44) // ✅ Fixed size to prevent shifting

            Spacer()

            // ✅ Title Centered
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer()

            // ✅ Invisible Button to Balance Layout
            Button(action: {}) {
                Color.clear
            }
            .frame(width: 44, height: 44) // ✅ Same size as back button for balance
        }
        .padding(.horizontal)
        .frame(height: 50)
        .background(Color.black)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 { // ✅ Detect swipe from left to right
                        navigateBack()
                    }
                }
        )
    }

    private func navigateBack() {
        if navigation.path.count > 1 {
            navigation.path.removeLast()
        } else {
            navigation.navigateToHome()
        }
    }
}
