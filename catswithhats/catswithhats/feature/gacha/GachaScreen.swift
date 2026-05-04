//
//  GachaScreen.swift
//  catswithhats
//

import SwiftUI

struct GachaScreen: View {
    @State private var store: GachaStore

    init(databaseService: any DatabaseService) {
        _store = State(initialValue: GachaStore(databaseService: databaseService))
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

    private func contentView(_ state: GachaState) -> some View {
        Text("Gacha")
            .navigationTitle("Gacha")
            .onAppear { store.send(.onAppear) }
    }
}
