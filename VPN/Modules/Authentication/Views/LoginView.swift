import Firebase
import GoogleSignIn
import SwiftUI

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
                            Toggle(
                                LocalizedStringKey("remember_me"),
                                isOn: $rememberMe
                            )
                            .font(.system(size: 18))
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
                                title: "sign_in",
                                action: {
                                    AnalyticsManager.shared.trackEvent(EventName.TAP.SIGNIN)
                                    
                                    authViewModel.signIn(
                                        email: email, password: password,
                                        rememberMe: rememberMe)
                                },
                                isLoading: authViewModel.loadingButtonType
                                    == .signIn)

                            GoogleAuthButton(
                                title: "sign_in_with_google",
                                action: {
                                    AnalyticsManager.shared.trackEvent(EventName.TAP.SIGNUP_GOOGLE)
                                    
                                    authViewModel.signInWithGoogle(
                                        rememberMe: rememberMe)
                                },
                                isLoading: authViewModel.loadingButtonType
                                    == .googleSignIn
                            )

                        }

                        HStack {
                            Text(LocalizedStringKey("no_account_sign_up"))
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
                AnalyticsManager.shared.trackEvent(EventName.VIEW.SIGN_IN_SCREEN)
                    
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
            Image(
                systemName: configuration.isOn
                    ? "checkmark.square.fill" : "square"
            )
            .foregroundColor(configuration.isOn ? .purple : .gray)
            .onTapGesture {
                configuration.isOn.toggle()
            }
            configuration.label
        }
    }
}
