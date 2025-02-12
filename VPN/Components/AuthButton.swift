import SwiftUI

struct AuthButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    var style: ButtonStyle = .primary

    enum ButtonStyle {
        case primary
        case secondary

        var backgroundColor: Color {
            switch self {
            case .primary: return Color.purple
            case .secondary: return Color.white
            }
        }

        var foregroundColor: Color {
            switch self {
            case .primary: return Color.white
            case .secondary: return Color.black
            }
        }

        var borderColor: Color {
            switch self {
            case .primary: return Color.clear
            case .secondary: return Color.gray.opacity(0.5)
            }
        }
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(
                                tint: style.foregroundColor))
                } else {
                    Text(LocalizedStringKey(title))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(style.foregroundColor)
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
