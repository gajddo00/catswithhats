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
            // TODO: fetch coin balance from databaseService
            break
        }
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
