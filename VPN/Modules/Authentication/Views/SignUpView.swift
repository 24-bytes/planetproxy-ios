import SwiftUI
import Firebase
import GoogleSignIn

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sign up")
                .font(.title)
                .bold()
            
            Text("Start your 30-day free trial.")
                .foregroundColor(.gray)
            
            nameField
            emailField
            passwordField
            createAccountButton
            googleSignUpButton
            loginPrompt
            skipButton
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Message"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name*")
                .foregroundColor(.gray)
            TextField("Enter your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email*")
                .foregroundColor(.gray)
            TextField("Enter your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password*")
                .foregroundColor(.gray)
            SecureField("Create a password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Must be at least 8 characters.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    private var createAccountButton: some View {
        Button(action: signUp) {
            Text("Create account")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .cornerRadius(8)
        }
    }
    
    private var googleSignUpButton: some View {
        Button(action: signInWithGoogle) {
            HStack {
                Image("google_logo")
                Text("Sign up with Google")
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
    
    private var loginPrompt: some View {
        HStack {
            Text("Already have an account?")
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Log in")
                    .foregroundColor(.purple)
            }
        }
    }
    
    private var skipButton: some View {
        Button(action: skipForNow) {
            Text("Skip for Now")
                .foregroundColor(.purple)
        }
    }
    
    private func signUp() {
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        
        guard password.count >= 8 else {
            alertMessage = "Password must be at least 8 characters"
            showingAlert = true
            return
        }
        
        authViewModel.signUp(email: email, password: password)
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
    
    private func skipForNow() {
        // Implement skip functionality
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}