import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Start your 30-day free trial.")
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Must be at least 8 characters.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical)
            
            Button(action: {
                viewModel.signUp(email: email, password: password)
            }) {
                Text("Create account")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            
            Button(action: {
                viewModel.signInWithGoogle()
            }) {
                HStack {
                    Image("google_logo") // Add this image to your assets
                    Text("Sign up with Google")
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            
            HStack {
                Text("Already have an account?")
                Button("Log in") {
                    dismiss()
                }
                .foregroundColor(.purple)
            }
            
            Button("Skip for Now") {
                // Handle skip action
            }
            .foregroundColor(.purple)
            .padding(.top)
        }
        .padding()
        .alert("Error", isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
            Button("OK") {
                viewModel.errorMessage = ""
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
