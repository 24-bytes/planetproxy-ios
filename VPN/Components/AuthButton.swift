import SwiftUI

struct AuthButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var style: ButtonStyle = .primary

    enum ButtonStyle {
        case primary
        case secondary

        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color.purple // Updated to match UI design
            case .secondary:
                return Color.white
            }
        }

        var foregroundColor: Color {
            switch self {
            case .primary:
                return Color.white
            case .secondary:
                return Color.black
            }
        }

        var borderColor: Color {
            switch self {
            case .primary:
                return Color.clear
            case .secondary:
                return Color.gray.opacity(0.5)
            }
        }
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                } else {
                    HStack {
                        if title.contains("Google") {
                            Image("google_logo") // Make sure to add google_logo in Assets.xcassets
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }

                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(style.foregroundColor)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(style.backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style.borderColor, lineWidth: 1)
            )
        }
        .disabled(isLoading)
    }
}

struct AuthButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            AuthButton(title: "Sign In", action: {})
            AuthButton(title: "Sign In with Google", action: {}, style: .secondary)
            AuthButton(title: "Loading...", action: {}, isLoading: true)
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Preview with a dark background
    }
}
