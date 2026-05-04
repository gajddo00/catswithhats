//
//  ContentView.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import SwiftUI

struct ContentView: View {
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
            NavigationStack {
                HomeScreen(databaseService: databaseService)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .catDetail(let cat):
                            Text(cat.name) // TODO: replace with CatDetailScreen
                        }
                    }
            }
        } else {
            LoginScreen(authService: authService) {
                isAuthenticated = true
            }
        }
    }
}
