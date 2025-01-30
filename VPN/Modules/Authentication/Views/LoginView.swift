import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingSignUp = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Log in")
                .font(.title)
                .bold()
            
            Text("Welcome back! Please enter your details.")
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .foregroundColor(.gray)
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .foregroundColor(.gray)
                SecureField("••••••••", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Toggle("Remember for 30 days", isOn: $rememberMe)
                    .toggleStyle(CheckboxToggleStyle())
                
                Spacer()
                
                Button("Forgot password?") {
                    forgotPassword()
                }
                .foregroundColor(.purple)
            }
            
            Button(action: signIn) {
                Text("Sign in")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            
            Button(action: signInWithGoogle) {
                HStack {
                    Image("google_logo") // Add this image to your assets
                    Text("Sign in with Google")
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            
            HStack {
                Text("Don't have an account?")
                Button(action: { showingSignUp = true }) {
                    Text("Sign up")
                        .foregroundColor(.purple)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: skipForNow) {
                Text("Skip for Now")
                    .foregroundColor(.purple)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
    }
    
    private func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            } else {
                // Navigate to main app
                // You'll need to implement this navigation
            }
        }
    }
    
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: UIApplication.shared.windows.first?.rootViewController ?? UIViewController()) { user, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                    return
                }
                // Navigate to main app
                // You'll need to implement this navigation
            }
        }
    }
    
    private func forgotPassword() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email address"
            showingAlert = true
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "Password reset email sent"
            }
            showingAlert = true
        }
    }
    
    private func skipForNow() {
        // Implement skip functionality
        // Navigate to main app with limited functionality
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .purple : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
