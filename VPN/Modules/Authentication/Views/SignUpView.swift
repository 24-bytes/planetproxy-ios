import SwiftUI
import Firebase
import GoogleSignIn

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sign up")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Start your 30-day free trial.")
                                .foregroundColor(.gray)
                        }
                        
                        // Form Fields
                        VStack(spacing: 16) {
                            AuthTextField(
                                title: "Name",
                                placeholder: "Enter your name",
                                text: $name
                            )
                            
                            AuthTextField(
                                title: "Email",
                                placeholder: "Enter your email",
                                text: $email
                            )
                            
                            AuthTextField(
                                title: "Password",
                                placeholder: "Create a password",
                                text: $password,
                                isSecure: true
                            )
                            
                            if let errorMessage = authViewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))
                            }
                        }
                        
                        // Buttons
                        VStack(spacing: 16) {
                            AuthButton(
                                title: "Create account",
                                action: { authViewModel.signUp(email: email, password: password) },
                                isLoading: authViewModel.isLoading
                            )
                            
                            AuthButton(
                                title: "Sign up with Google",
                                action: { authViewModel.signInWithGoogle() },
                                isLoading: authViewModel.isLoading,
                                style: .secondary
                            )
                        }
                        .padding(.top, 8)
                        
                        // Sign In Prompt
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            
                            Button("Log in") {
                                dismiss()
                            }
                            .foregroundColor(.purple)
                        }
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                    .padding(24)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    
}
