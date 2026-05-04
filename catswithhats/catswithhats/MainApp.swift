//
//  MainApp.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import FirebaseCore
import RevenueCat
import SwiftUI
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MainApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate

    @State private var authService: any AuthService = FirebaseAuthService()
    @State private var databaseService: any DatabaseService = FirebaseDatabaseService()
    init() {
		// Firebase
        FirebaseApp.configure()
        _authService = State(initialValue: FirebaseAuthService())
        _databaseService = State(initialValue: FirebaseDatabaseService())

		// Revenue Cat
		Purchases.configure(withAPIKey: "test_bUnjnqqIawpJDHUBwaidVZkftof")
    }

    var body: some Scene {
        WindowGroup {
            LandingScreen(
                authService: authService,
                databaseService: databaseService
            )
        }
    }
}
