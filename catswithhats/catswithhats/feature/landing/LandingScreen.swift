//
//  LandingScreen.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import SwiftUI

struct LandingScreen: View {
    let authService: any AuthService
    let databaseService: any DatabaseService

    @State private var isAuthenticated: Bool

    init(authService: any AuthService, databaseService: any DatabaseService) {
        self.authService = authService
        self.databaseService = databaseService
        _isAuthenticated = State(initialValue: authService.currentUserID != nil)
    }

    var body: some View {
        if isAuthenticated, let userID = authService.currentUserID {
            MainTabScreen(
                databaseService: databaseService,
                userID: userID
            )
        } else {
            LoginScreen(
                authService: authService,
                databaseService: databaseService
            ) {
                isAuthenticated = true
            }
        }
    }
}
