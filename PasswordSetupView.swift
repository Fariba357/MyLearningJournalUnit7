import SwiftUI

struct PasswordSetupView: View {
    var name: String
    var email: String

    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var navigateToSignin = false

    var body: some View {
        VStack(spacing: 20) {
            SecureField("Enter your password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm your password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Sign Up") {
                if password == confirmPassword && !password.isEmpty {
                    errorMessage = nil
                    PersistenceController.shared.saveUser(
                        name: name,
                        email: email,
                        password: password
                    )
                    navigateToSignin = true
                } else {
                    errorMessage = "Passwords do not match"
                }
            }

            NavigationLink(destination: SigninView(),
                           isActive: $navigateToSignin) {
                EmptyView()
            }
        }
        .padding()
    }
}
