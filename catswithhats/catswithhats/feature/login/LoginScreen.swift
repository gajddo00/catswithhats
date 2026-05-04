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

    init(
        authService: any AuthService,
        databaseService: any DatabaseService,
        onLoginComplete: @escaping () -> Void
    ) {
        _store = State(
            initialValue: LoginStore(
                authService: authService,
                databaseService: databaseService
            )
        )
        self.onLoginComplete = onLoginComplete
    }

    var body: some View {
        ZStack {
            Color.cPink.ignoresSafeArea()

            ScrollView {
                VStack(spacing: .extraLarge) {
                    heroImage
                    loginCard
                    chips
                    footer
                }
                .padding(.horizontal, .regular)
                .padding(.vertical, .extraLarge)
            }
            .scrollIndicators(.hidden)
        }
        .onChange(of: store.state.didLogin) { _, didLogin in
            if didLogin { onLoginComplete() }
        }
    }
}

private extension LoginScreen {
    var heroImage: some View {
        Image("Logo")
            .resizable()
            .scaledToFill()
            .frame(width: 240, height: 240)
            .stickerStyle(Circle())
            .rotationEffect(.degrees(-3))
            .padding(.top, .regular)
    }

    var loginCard: some View {
        VStack(spacing: .regular) {
            VStack(spacing: .min) {
                Text("welcome_back")
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(Color.cInk)
                Text("login_subtitle")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.cSubtitle)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: .small) {
                Text("username")
                    .font(.system(size: 12, weight: .black))
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(Color.cSubtitle)
                    .padding(.leading, .min)

                TextField(
                    "username_placeholder",
                    text: store.binding(\.username, action: LoginStore.Action.usernameChanged)
                )
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.cInk)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, .regular)
                .padding(.vertical, 14)
                .background(Color.cField)
                .stickerStyle(shadowOffset: 0)
            }

            Button {
                store.send(.submitTapped)
            } label: {
                if store.state.isLoading {
                    ProgressView()
                        .tint(Color.cInk)
                } else {
                    HStack(spacing: 6) {
                        Text("start_playing")
                            .textCase(.uppercase)
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 22))
                    }
                }
            }
            .buttonStyle(.sticker)
            .disabled(store.state.username.isEmpty || store.state.isLoading)
            .padding(.top, .min)

            Text("login_hint")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color.cSubtitle)
                .multilineTextAlignment(.center)
                .padding(.top, .min)

            if let errorMessage = store.state.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .stickerStyle(cornerRadius: .large)
    }

    var chips: some View {
        HStack(spacing: .regular) {
            StickerChip(
                icon: "sparkles",
                label: "chip_new_hats",
                backgroundColor: .cMint,
                rotation: 3
            )
            StickerChip(
                icon: "heart.fill",
                label: "chip_top_kitties",
                backgroundColor: .cBlue,
                rotation: -2
            )
        }
    }

    var footer: some View {
        Text("footer_copyright")
            .font(.system(size: 12, weight: .bold))
            .tracking(1.5)
            .textCase(.uppercase)
            .foregroundStyle(Color.cSubtitle)
    }
}
