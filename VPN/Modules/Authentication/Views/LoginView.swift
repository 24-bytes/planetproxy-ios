// swiftlint:disable line_length
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
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Log in")
                .font(.title)
                .bold()

            Text("Welcome back? Please enter your details.")
                .foregroundColor(.gray)
            
            emailField
            passwordField
            rememberMeAndForgotPassword
            signInButton
            googleSignInButton
            signUpPrompt
            skipButton
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Message"), 
                  message: Text(alertMessage), 
                  dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .foregroundColor(.gray)
            TextField("Enter your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .foregroundColor(.gray)
            SecureField("••••••••", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var rememberMeAndForgotPassword: some View {
        HStack {
            Toggle("Remember for 30 days", isOn: $rememberMe)
                .toggleStyle(CheckboxToggleStyle())
            Spacer()
            Button("Forgot password?") {
                forgotPassword()
            }
            .foregroundColor(.purple)
        }
    }
    
    private var signInButton: some View {
        Button(action: signIn) {
            Text("Sign in")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .cornerRadius(8)
        }
    }
    
    private var googleSignInButton: some View {
        Button(action: signInWithGoogle) {
            HStack {
                Image("google_logo")
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
    }
    
    private var signUpPrompt: some View {
        HStack {
            Text("Don't have an account?")
            Button(action: { showingSignUp = true }) {
                Text("Sign up")
                    .foregroundColor(.purple)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var skipButton: some View {
        Button(action: skipForNow) {
            Text("Skip for Now")
                .foregroundColor(.purple)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        authViewModel.signIn(email: email, password: password)
    }
    
    private func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            alertMessage = "Cannot present Google Sign-In"
            showingAlert = true
            return
        }
        
        let clientID = FirebaseApp.app()?.options.clientID ?? ""
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { user, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
                return
            }
            
            guard let user = user else {
                alertMessage = "Failed to get user information"
                showingAlert = true
                return
            }
            
            guard let idToken = user.authentication.idToken else {
                alertMessage = "Failed to get ID token"
                showingAlert = true
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.authentication.accessToken
            )
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
    
    private func forgotPassword() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email address"
            showingAlert = true
            return
        }
        authViewModel.resetPassword(email: email)
    }
    
    private func skipForNow() {
        // Implement skip functionality
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .purple : .gray)
                .font(.system(size: 20, weight: .regular, design: .default))
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