import Firebase
import GoogleSignIn
import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var rememberMe: Bool = false  // ✅ Added rememberMe toggle

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
                            Text(LocalizedStringKey("sign_up_title"))
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)

                            Text(LocalizedStringKey("start_trial_message"))
                                .foregroundColor(.gray)
                        }

                        // Form Fields
                        VStack(spacing: 16) {
                            AuthTextField(
                                titleKey: "name",
                                placeholderKey: "enter_name",
                                text: $name
                            )

                            AuthTextField(
                                titleKey: "email",
                                placeholderKey: "enter_email",
                                text: $email
                            )

                            AuthTextField(
                                titleKey: "password",
                                placeholderKey: "create_password",
                                text: $password,
                                isSecure: true
                            )

                            if let errorMessage = authViewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))
                            }
                        }

                        HStack {
                            Button(action: { rememberMe.toggle() }) {
                                Image(
                                    systemName: rememberMe
                                        ? "checkmark.square.fill" : "square"
                                )
                                .foregroundColor(.purple)
                            }
                            Text(LocalizedStringKey("remember_me"))
                                .foregroundColor(.white)
                        }
                        // Buttons
                        VStack(spacing: 16) {
                            AuthButton(
                                title: "sign_up",
                                action: {
                                    authViewModel.signUp(
                                        email: email, password: password,
                                        rememberMe: rememberMe)
                                },
                                isLoading: authViewModel.loadingButtonType
                                    == .signUp)

                            GoogleAuthButton(
                                title: "sign_up_with_google",
                                action: {
                                    authViewModel.signInWithGoogle(
                                        rememberMe: rememberMe)
                                },
                                isLoading: authViewModel.loadingButtonType
                                    == .googleSignIn
                            )
                        }
                        .padding(.top, 8)

                        // Sign In Prompt
                        HStack {
                            Text(LocalizedStringKey("already_have_account"))
                                .foregroundColor(.gray)

                            Button(LocalizedStringKey("sign_in")) {
                                dismiss()
                            }
                            .foregroundColor(.purple)
                        }

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
