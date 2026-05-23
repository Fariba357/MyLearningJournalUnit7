import SwiftUI

struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var errorMessage: String?
    @State private var navigateToPassword = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Enter your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Next") {
                if isValidEmail(email) {
                    errorMessage = nil
                    navigateToPassword = true
                } else {
                    errorMessage = "Invalid email address"
                }
            }

            NavigationLink(destination: PasswordSetupView(name: name, email: email),
                           isActive: $navigateToPassword) {
                EmptyView()
            }
        }
        .padding()
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
