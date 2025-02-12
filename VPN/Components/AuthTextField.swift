import SwiftUI

struct AuthTextField: View {
    let titleKey: String
    let placeholderKey: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(LocalizedStringKey(titleKey))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            if isSecure {
                SecureField(LocalizedStringKey(placeholderKey), text: $text)
                    .textFieldStyle(AuthTextFieldStyle())
            } else {
                TextField(LocalizedStringKey(placeholderKey), text: $text)
                    .textFieldStyle(AuthTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(
                        titleKey == "email" ? .emailAddress : .default)
            }
        }
    }
}

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.system(size: 16))
    }
}

struct AuthTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AuthTextField(
                titleKey: "email", placeholderKey: "enter_email",
                text: .constant(""))
            AuthTextField(
                titleKey: "password", placeholderKey: "enter_password",
                text: .constant(""), isSecure: true)
        }
        .padding()
    }
}
