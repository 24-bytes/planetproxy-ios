import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showingSignUp: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedStringKey("sign_in"))
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)

                            Text(LocalizedStringKey("welcome_back"))
                                .foregroundColor(.gray)
                        }

                        VStack(spacing: 16) {
                            AuthTextField(
                                titleKey: "email",
                                placeholderKey: "enter_email",
                                text: $email
                            )
                            AuthTextField(
                                titleKey: "password",
                                placeholderKey: "enter_password",
                                text: $password,
                                isSecure: true
                            )
                        }

                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                                .transition(.opacity)
                        }

                        HStack {
                            Toggle(LocalizedStringKey("remember_me"), isOn: $rememberMe)
                                .toggleStyle(CheckboxToggleStyle())
                                .foregroundColor(.gray)

                            Spacer()

                            Button(LocalizedStringKey("forgot_password")) {
                                authViewModel.resetPassword(email: email)
                            }
                            .foregroundColor(.purple)
                        }

                        VStack(spacing: 16) {
                            AuthButton(
                                titleKey: "sign_in",
                                action: {
                                    authViewModel.signIn(email: email, password: password, rememberMe: rememberMe)
                                },
                                isLoading: authViewModel.isLoading
                            )

                            AuthButton(
                                titleKey: "sign_in_with_google",
                                action: {
                                    authViewModel.signInWithGoogle(rememberMe: rememberMe)
                                },
                                isLoading: authViewModel.isLoading,
                                style: .secondary
                            )
                        }

                        HStack {
                            Text(LocalizedStringKey("already_have_account"))
                                .foregroundColor(.gray)

                            Button(LocalizedStringKey("sign_up")) {
                                showingSignUp = true
                            }
                            .foregroundColor(.purple)
                        }
                    }
                    .padding(24)
                }
            }
            .onAppear {
                if !authViewModel.rememberedEmail.isEmpty {
                    email = authViewModel.rememberedEmail
                    password = authViewModel.rememberedPassword
                    rememberMe = true
                }
            }
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
                .foregroundColor(configuration.isOn ? .purple : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}
