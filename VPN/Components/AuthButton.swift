import SwiftUI

struct AuthButton: View {
    let titleKey: String
    let action: () -> Void
    var isLoading: Bool = false
    var style: ButtonStyle = .primary

    enum ButtonStyle {
        case primary
        case secondary

        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color.purple
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
                        if titleKey.contains("sign_in_with_google") || titleKey.contains("sign_up_with_google") {
                            Image("google_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        Text(LocalizedStringKey(titleKey))
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
