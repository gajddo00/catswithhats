//
//  CatCollectionScreen.swift
//  catswithhats
//

import SwiftUI

struct CatCollectionScreen: View {
    @State private var store: CatCollectionStore

    init(databaseService: any DatabaseService) {
        _store = State(initialValue: CatCollectionStore(databaseService: databaseService))
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

    private func contentView(_ state: CatCollectionState) -> some View {
        Text("Collection")
            .navigationTitle("Collection")
            .onAppear { store.send(.onAppear) }
    }
}
