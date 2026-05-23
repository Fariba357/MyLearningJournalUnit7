import SwiftUI
import CoreData

struct SigninView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var navigateToHome = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)

            SecureField("Enter your password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Login") {
                if validateUser(email: email, password: password) {
                    errorMessage = nil
                    navigateToHome = true
                } else {
                    errorMessage = "Invalid email or password"
                }
            }

            NavigationLink(destination: HomeView(),
                           isActive: $navigateToHome) {
                EmptyView()
            }
        }
        .padding()
    }

    func validateUser(email: String, password: String) -> Bool {
        let context = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print("Error fetching user: \(error)")
            return false
        }
    }
}
