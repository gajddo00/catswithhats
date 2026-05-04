//
//  LoginScreen.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import SwiftUI

struct LoginScreen: View {
    @State private var store: LoginStore
    let onLoginComplete: () -> Void

    init(authService: any AuthService, onLoginComplete: @escaping () -> Void) {
        _store = State(initialValue: LoginStore(authService: authService))
        self.onLoginComplete = onLoginComplete
    }

    var body: some View {
        VStack(spacing: .regular) {
            Text("welcome")
                .font(.largeTitle)
                .padding(.bottom, .large)

            TextField(
                "username",
                text: store.binding(\.username, action: LoginStore.Action.usernameChanged)
            )
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            Button {
                store.send(.submitTapped)
            } label: {
                if store.state.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("continue")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(store.state.username.isEmpty || store.state.isLoading)

            if let errorMessage = store.state.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .padding()
        .onChange(of: store.state.didLogin) { _, didLogin in
            if didLogin { onLoginComplete() }
        }
    }
}
