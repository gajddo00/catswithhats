//
//  ShopScreen.swift
//  catswithhats
//

import SwiftUI

struct ShopScreen: View {
    @State private var store: ShopStore
    @State private var showPaywall = false

    init(databaseService: any DatabaseService) {
        _store = State(initialValue: ShopStore(databaseService: databaseService))
    }

    var body: some View {
        switch store.state.uiState {
        case .loading:
            ProgressView()
        case .error(let message):
            Text(message)
                .foregroundStyle(.red)
        case .content(let state):
            contentView(state)
        }
    }

    private func contentView(_ state: ShopState) -> some View {
        VStack {
            Button("Open Paywall") {
                showPaywall = true
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Shop")
        .onAppear { store.send(.onAppear) }
        .sheet(isPresented: $showPaywall) {
            PaywallScreen()
        }
    }
}
