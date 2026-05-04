//
//  LoginStore.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class LoginStore: Store {
    private(set) var state = State()
    private let authService: any AuthService
    
    init(authService: any AuthService) {
        self.authService = authService
    }
    
    func send(_ action: Action) {
        switch action {
        case .usernameChanged(let value):
            state.username = value
            
        case .submitTapped:
            guard !state.username.isEmpty, !state.isLoading else { return }
            state.isLoading = true
            state.errorMessage = nil
            Task { await signIn() }
            
        case .signInSucceeded:
            state.isLoading = false
            state.didLogin = true
            
        case .signInFailed(let message):
            state.isLoading = false
            state.errorMessage = message
        }
    }
}

private extension LoginStore {
    func signIn() async {
        do {
            _ = try await authService.signInAnonymously(displayName: state.username)
            send(.signInSucceeded)
        } catch {
            send(.signInFailed(error.localizedDescription))
        }
    }
}

extension LoginStore {
    enum Action {
        case usernameChanged(String)
        case submitTapped
        case signInSucceeded
        case signInFailed(String)
    }
    
    struct State {
        var username: String = ""
        var isLoading: Bool = false
        var errorMessage: String?
        var didLogin: Bool = false
    }
}
