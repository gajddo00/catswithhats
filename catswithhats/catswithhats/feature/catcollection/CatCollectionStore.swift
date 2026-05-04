//
//  CatCollectionStore.swift
//  catswithhats
//

import Foundation
import Observation

private let maxRerolls = 3

private let mockCards: [Card] = [
    Card(id: "1", name: "Detective Mittens", description: "Solving the mystery of where the treats went since 2024.", assetID: "detective_mittens", rarity: .legendary, weight: 10),
    Card(id: "2", name: "Captain Whiskers", description: "Sailing the seven seas in search of the perfect nap spot.", assetID: "captain_whiskers", rarity: .rare, weight: 25),
    Card(id: "3", name: "Sir Fluffington", description: "Knighted for outstanding service in the field of zoomies.", assetID: "sir_fluffington", rarity: .uncommon, weight: 40),
    Card(id: "4", name: "Tabby McHatface", description: "Just here for the chin scratches.", assetID: "tabby_mchatface", rarity: .common, weight: 80),
]

@Observable
final class CatCollectionStore: Store {
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
            Task { await load() }
        case .reroll:
            guard state.rerollsRemaining > 0 else { return }
            state.rerollsRemaining -= 1
            state.freeCard = mockCards.filter { $0.id != state.freeCard?.id }.randomElement() ?? mockCards.randomElement()
        case .acceptCard:
            guard let card = state.freeCard else { return }
            state.ownedCards.append(card)
            state.freeCard = nil
            // TODO: persist to databaseService
        }
    }
}

private extension CatCollectionStore {
    func load() async {
        state.isLoading = true
        defer { state.isLoading = false }

        // TODO: replace with real service call
        state.availableCards = mockCards
        state.freeCard = mockCards.randomElement()
        state.rerollsRemaining = maxRerolls
    }
}

extension CatCollectionStore {
    enum Action {
        case onAppear
        case reroll
        case acceptCard
    }

    struct State {
        var ownedCards: [Card] = []
        var freeCard: Card?
        var availableCards: [Card] = []
        var rerollsRemaining: Int = maxRerolls
        var isLoading: Bool = true
        var errorMessage: String?

        var isEmpty: Bool { ownedCards.isEmpty }
    }
}
