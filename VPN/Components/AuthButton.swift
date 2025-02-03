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
                return Color.blue
            case .secondary:
                return Color.white
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return Color.white
            case .secondary:
                return Color.blue
            }
        }
        
        var borderColor: Color {
            switch self {
            case .primary:
                return Color.clear
            case .secondary:
                return Color.blue
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
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
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
        VStack {
            AuthButton(title: "Sign In", action: {})
            AuthButton(title: "Sign In with Google", action: {}, style: .secondary)
            AuthButton(title: "Loading...", action: {}, isLoading: true)
        }
        .padding()
    }
}
