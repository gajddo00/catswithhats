//
//  MainTabStore.swift
//  catswithhats
//

import Foundation
import Observation

@Observable
final class MainTabStore: Store {
    private(set) var state = State()
    private let databaseService: any DatabaseService
    private let userID: String

    init(databaseService: any DatabaseService, userID: String) {
        self.databaseService = databaseService
        self.userID = userID
    }

    func send(_ action: Action) {
        switch action {
        case .onAppear:
            Task { await seed() }
        }
    }
}

private extension MainTabStore {
    func seed() async {
        try? await databaseService.seedCardsIfNeeded()
    }
}

extension MainTabStore {
    enum Action {
        case onAppear
    }

    struct State {
        var coins: Int = 1250
    }
}
