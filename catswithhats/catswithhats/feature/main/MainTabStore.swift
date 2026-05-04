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
            Task {
                await seed()
                await refresh()
            }
        case .refresh:
            Task { await refresh() }
        }
    }
}

private extension MainTabStore {
    func seed() async {
        try? await databaseService.seedCardsIfNeeded()
    }

    func refresh() async {
        do {
            let user = try await databaseService.fetchUser(id: userID)
            state.coins = user?.tokens ?? 0
        } catch {
            // surface later if needed
        }
    }
}

extension MainTabStore {
    enum Action {
        case onAppear
        case refresh
    }

    struct State {
        var coins: Int = 0
    }
}
