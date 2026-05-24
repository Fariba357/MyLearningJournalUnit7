import CoreData
import SwiftUI
// User entity model
struct User {
    var name: String
    var email: String
    var password: String
    var biometricRegistered: Bool}
// Attendance entity model
struct Attendance {
    var email: String
    var action: String
    var date: Date
    var locationMatched: Bool}
// Core Data helper
class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "AttendanceApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }       }    }
    // Save user details
    func saveUser(name: String, email: String, password: String, biometricRegistered: Bool = false) {
        let context = container.viewContext
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context)
        user.setValue(name, forKey: "name")
        user.setValue(email, forKey: "email")
        user.setValue(password, forKey: "password")
        user.setValue(biometricRegistered, forKey: "biometricRegistered")
        do {
            try context.save()
            print("User saved successfully!")
        } catch {
            print("Failed to save user: \(error)")}  }
    // Save attendance record
    func saveAttendance(email: String, action: String, locationMatched: Bool) {
        let context = container.viewContext
        let record = NSEntityDescription.insertNewObject(forEntityName: "AttendanceEntity", into: context)
        record.setValue(email, forKey: "email")
        record.setValue(action, forKey: "action")
        record.setValue(Date(), forKey: "date")
        record.setValue(locationMatched, forKey: "locationMatched")
        do {
            try context.save()
            print("Attendance saved successfully!")
        } catch {
            print("Failed to save attendance: \(error)")  } }
    // Check if biometric is registered
    func isBiometricRegistered(email: String) -> Bool {
        let context = container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "email == %@", email)
        do {
            if let user = try context.fetch(request).first {
                return user.value(forKey: "biometricRegistered") as? Bool ?? false
            }
        } catch {
            print("Error checking biometric: \(error)")    }
        return false    }
    // Register biometric
    func registerBiometric(email: String) {
        let context = container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "email == %@", email)
        do {
            if let user = try context.fetch(request).first {
                user.setValue(true, forKey: "biometricRegistered")
                try context.save()
                print("Biometric registered successfully!")
            }
        } catch {
            print("Error registering biometric: \(error)")
        }
    }
    // Check if user already checked in/out today
    func alreadyCheckedToday(email: String, action: String) -> Bool {
        let context = container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "AttendanceEntity")
        request.predicate = NSPredicate(format: "email == %@ AND action == %@ AND date >= %@",
                                        email, action, Calendar.current.startOfDay(for: Date()) as NSDate)

        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking attendance: \(error)")
            return false
        }
    }
}
