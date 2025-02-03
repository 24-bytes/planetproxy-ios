import SwiftUI

struct AuthTextField: View {
    let title: String
    let placeholder: String
    let text: Binding<String>
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.primary)
                .font(.system(size: 14, weight: .medium))
            
            if isSecure {
                SecureField(placeholder, text: text)
                    .textFieldStyle(AuthTextFieldStyle())
            } else {
                TextField(placeholder, text: text)
                    .textFieldStyle(AuthTextFieldStyle())
                    .autocapitalization(.none)
            }
        }
    }
}

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
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
