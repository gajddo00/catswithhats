//
//  ShopStore.swift
//  catswithhats
//

import Foundation
import Observation

@Observable
final class ShopStore: Store {
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

private extension ShopStore {
    func load() async {
        state.uiState = .loading
        // TODO: fetch shop items
        state.uiState = .content(.init())
    }
}

extension ShopStore {
    enum Action {
        case onAppear
    }

    struct State {
        var uiState: UiState<ShopState> = .loading
    }
}
