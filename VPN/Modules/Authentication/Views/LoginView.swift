import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showingSignUp = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Log in")
                            .font(.system(size: 30, weight: .bold))
                        Text("Welcome back! Please enter your details.")
                            .foregroundColor(.gray)
                    }
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        AuthTextField(
                            title: "Email",
                            placeholder: "Enter your email",
                            text: $email
                        )
                        
                        AuthTextField(
                            title: "Password",
                            placeholder: "Enter your password",
                            text: $password,
                            isSecure: true
                        )
                        
                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }
                    }
                    
                    // Remember Me & Forgot Password
                    HStack {
                        Toggle("Remember for 30 days", isOn: $rememberMe)
                            .toggleStyle(CheckboxToggleStyle())
                        Spacer()
                        Button("Forgot password?") {
                            if !email.isEmpty {
                                authViewModel.resetPassword(email: email)
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    .font(.system(size: 14))
                    
                    // Buttons
                    VStack(spacing: 16) {
                        AuthButton(
                            title: "Sign in",
                            action: { authViewModel.signIn(email: email, password: password) },
                            isLoading: authViewModel.isLoading
                        )
                        
                        AuthButton(
                            title: "Sign in with Google",
                            action: { authViewModel.signInWithGoogle() },
                            isLoading: authViewModel.isLoading,
                            style: .secondary
                        )
                    }
                    .padding(.top, 8)
                    
                    // Sign Up Prompt
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        Button("Sign up") {
                            showingSignUp = true
                        }
                        .foregroundColor(.blue)
                    }
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .blue : .gray)
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
            .environmentObject(AuthViewModel())
    }
}
