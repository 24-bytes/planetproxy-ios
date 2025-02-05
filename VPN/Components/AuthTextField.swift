import SwiftUI

struct AuthTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(AuthTextFieldStyle())
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(AuthTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(title == "Email" ? .emailAddress : .default)
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
            AuthTextField(title: "Email", placeholder: "Enter your email", text: .constant(""))
            AuthTextField(title: "Password", placeholder: "Enter your password", text: .constant(""), isSecure: true)
        }
        .padding()
    }
}
