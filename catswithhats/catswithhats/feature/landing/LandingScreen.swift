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
        if isAuthenticated {
            VStack(spacing: .regular) {
                Text("logged_in")
                    .font(.title)
                Button("sign_out") {
                    try? authService.signOut()
                    isAuthenticated = false
                }
                .buttonStyle(.bordered)
            }
            .padding()
        } else {
            LoginScreen(authService: authService) {
                isAuthenticated = true
            }
        }
    }
}
