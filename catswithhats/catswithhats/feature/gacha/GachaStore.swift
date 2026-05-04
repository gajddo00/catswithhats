//
//  GachaStore.swift
//  catswithhats
//

import Foundation
import Observation

@Observable
final class GachaStore: Store {
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

private extension GachaStore {
    func load() async {
        state.uiState = .loading
        // TODO: fetch gacha data
        state.uiState = .content(.init())
    }
}

extension GachaStore {
    enum Action {
        case onAppear
    }

    struct State {
        var uiState: UiState<GachaState> = .loading
    }
}
