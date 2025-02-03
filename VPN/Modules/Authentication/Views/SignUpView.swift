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
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create Account")
                            .font(.system(size: 30, weight: .bold))
                        Text("Sign up to get started!")
                            .foregroundColor(.gray)
                    }
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        TextField("Name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }
                    }
                    
                    // Buttons
                    VStack(spacing: 16) {
                        Button(action: { 
                            if password == confirmPassword {
                                authViewModel.signUp(email: email, password: password)
                            }
                        }) {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(authViewModel.isLoading)
                        
                        Button(action: { authViewModel.signInWithGoogle() }) {
                            Text("Sign up with Google")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(authViewModel.isLoading)
                    }
                    .padding(.top, 8)
                    
                    // Sign In Prompt
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Button("Sign in") {
                            dismiss()
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
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}