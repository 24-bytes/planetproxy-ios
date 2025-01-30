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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sign up")
                .font(.title)
                .bold()
            
            Text("Start your 30-day free trial.")
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Name*")
                    .foregroundColor(.gray)
                TextField("Enter your name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email*")
                    .foregroundColor(.gray)
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password*")
                    .foregroundColor(.gray)
                SecureField("Create a password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Must be at least 8 characters.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Button(action: signUp) {
                Text("Create account")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            
            Button(action: signInWithGoogle) {
                HStack {
                    Image("google_logo") // Add this image to your assets
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
            
            HStack {
                Text("Already have an account?")
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Log in")
                        .foregroundColor(.purple)
                }
            }
            
            Button(action: skipForNow) {
                Text("Skip for Now")
                    .foregroundColor(.purple)
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func signUp() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            } else {
                // Update user profile with name
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { error in
                    if let error = error {
                        alertMessage = error.localizedDescription
                        showingAlert = true
                    }
                }
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
    
    private func skipForNow() {
        // Implement skip functionality
        // Navigate to main app with limited functionality
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
