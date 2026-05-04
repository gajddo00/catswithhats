//
//  MainApp.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import FirebaseCore
import RevenueCat
import SwiftUI

@main
struct MainApp: App {
    @State private var authService: any AuthService
    @State private var databaseService: any DatabaseService

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
