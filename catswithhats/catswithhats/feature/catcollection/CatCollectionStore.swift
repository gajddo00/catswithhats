//
//  CatCollectionStore.swift
//  catswithhats
//

import Foundation
import Observation

@Observable
final class CatCollectionStore: Store {
    private(set) var state = State()
    private let databaseService: any DatabaseService

    init(databaseService: any DatabaseService) {
        self.databaseService = databaseService
    }

    func send(_ action: Action) {
        switch action {
        case .onAppear:
            Task { await load() }
        }
    }
}

private extension CatCollectionStore {
    func load() async {
        state.uiState = .loading
        // TODO: fetch cat collection
        state.uiState = .content(.init())
    }
}

extension CatCollectionStore {
    enum Action {
        case onAppear
    }

    struct State {
        var uiState: UiState<CatCollectionState> = .loading
    }
}
