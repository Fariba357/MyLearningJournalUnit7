import PackageDescription
let package = Package(
    name: "AttendanceApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "AttendanceApp", targets: ["AttendanceApp"])
    ],
    targets: [
        .executableTarget(
            name: "AttendanceApp",
            path: ".",
            sources: [
                "HomeView.swift",
                "NetworkManager.swift",
                "PasswordSetupView.swift",
                "SigninView.swift",
                "SignupView.swift",
                "UserModel.swift"
            ],
            resources: [
                // If you have Core Data model files (.xcdatamodeld), include them here
                // "AttendanceApp.xcdatamodeld"
            ]
        )
    ]
)
