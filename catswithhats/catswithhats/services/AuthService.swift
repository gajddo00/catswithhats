//
//  AuthService.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import FirebaseAuth
import Foundation

protocol AuthService {
    var currentUserID: String? { get }
    func signInAnonymously(displayName: String) async throws -> String
    func signOut() throws
}

final class FirebaseAuthService: AuthService {
    private var auth: Auth { Auth.auth() }

    var currentUserID: String? {
        auth.currentUser?.uid
    }

    func signInAnonymously(displayName: String) async throws -> String {
        let result = try await auth.signInAnonymously()
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
        return result.user.uid
    }

    func signOut() throws {
        try auth.signOut()
    }
}
