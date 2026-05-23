import SwiftUI

struct HomeView: View {
    @State private var message: String?

    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to Attendance App")
                .font(.title)
                .padding()

            Button("Check-In") {
                PersistenceController.shared.saveAttendance(
                    email: "user@example.com", // Replace with logged-in user email
                    action: "Check-In"
                )
                syncAttendance()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("Check-Out") {
                PersistenceController.shared.saveAttendance(
                    email: "user@example.com", // Replace with logged-in user email
                    action: "Check-Out"
                )
                syncAttendance()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)

            if let msg = message {
                Text(msg)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
    }

    func syncAttendance() {
        NetworkManager.shared.fetchData { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    message = "Attendance synced successfully!"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .noInternet:
                        message = "Error: No internet connection"
                    case .serverError:
                        message = "Error: Server returned an error"
                    }
                }
            }
        }
    }
}
