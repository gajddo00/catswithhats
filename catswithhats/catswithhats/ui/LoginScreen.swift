//
//  LoginScreen.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import SwiftUI

struct LoginScreen: View {
    let authService: AuthService
    let onLoginComplete: () -> Void

    @State private var username: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome")
                .font(.largeTitle)
                .padding(.bottom, 32)

            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            Button {
                Task { await login() }
            } label: {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(username.isEmpty || isLoading)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .padding()
    }

    private func login() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            _ = try await authService.signInAnonymously(displayName: username)
            onLoginComplete()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
