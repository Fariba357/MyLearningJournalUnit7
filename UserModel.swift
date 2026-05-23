import CoreData
import SwiftUI

// User entity model
struct User {
    var name: String
    var email: String
    var password: String
}

// Core Data helper
class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "AttendanceApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }

    func saveUser(name: String, email: String, password: String) {
        let context = container.viewContext
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context)
        user.setValue(name, forKey: "name")
        user.setValue(email, forKey: "email")
        user.setValue(password, forKey: "password")

        do {
            try context.save()
            print("User saved successfully!")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
}
