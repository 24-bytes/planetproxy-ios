import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showSignUp = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Log in")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Welcome back! Please enter your details.")
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Toggle("Remember for 30 days", isOn: $rememberMe)
                        .toggleStyle(CheckboxToggleStyle())
                    
                    Spacer()
                    
                    Button("Forgot password") {
                        // Handle forgot password
                    }
                    .foregroundColor(.purple)
                }
            }
            .padding(.vertical)
            
            Button(action: {
                viewModel.signIn(email: email, password: password)
            }) {
                Text("Sign in")
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
                    Text("Sign in with Google")
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
                Text("Don't have an account?")
                Button("Sign up") {
                    showSignUp = true
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
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .alert("Error", isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
            Button("OK") {
                viewModel.errorMessage = ""
            }
        } message: {
            Text(viewModel.errorMessage)
        }
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
