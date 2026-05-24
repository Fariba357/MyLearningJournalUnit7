import SwiftUI
import LocalAuthentication
import CoreLocation
struct HomeView: View {
    @State private var message: String?
    @State private var locationManager = CLLocationManager()
    let officeLocation = CLLocation(latitude: 34.3529, longitude: 62.2040) // Example office coordinates
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to Attendance App")
                .font(.title)
                .padding()
            Button("Check-In") {
                performCheckInOut(action: "Check-In")          }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
           Button("Check-Out") {
                performCheckInOut(action: "Check-Out")
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
       if let msg = message {
                Text(msg)
                    .foregroundColor(.blue)
                    .padding()
            }     }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
        }    }
    // Main attendance function
    func performCheckInOut(action: String) {
        let email = "user@example.com" // Replace with logged-in user email
        // Case 1: Biometric not registered
        guard PersistenceController.shared.isBiometricRegistered(email: email) else {
            message = "Please register your biometric first."
            PersistenceController.shared.registerBiometric(email: email)
            message = "Biometric registered successfully!"
            return
        }
        // Case 2: Authenticate biometric
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Authenticate to \(action)") { success, _ in
                if success {
                    if isAtOfficeLocation() {
                        if !PersistenceController.shared.alreadyCheckedToday(email: email, action: action) {
                            PersistenceController.shared.saveAttendance(email: email, action: action, locationMatched: true)
                            syncAttendance()
                            message = "Successfully \(action)!"
                        } else {
                            message = "You have already \(action)ed today."
                        }
                    } else {
                        message = "You are not on office premises."
                    }
                } else {
                    message = "Biometric authentication failed."
                }           }      }    }

    // GPS check
    func isAtOfficeLocation() -> Bool {
        guard let currentLocation = locationManager.location else { return false }
        let distance = currentLocation.distance(from: officeLocation)
        return distance < 50 // within 50 meters of office    }
    // Sync attendance with server
    func syncAttendance() {
        NetworkManager.shared.fetchData { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    message = "Attendance synced successfully!"         }
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
