//
//  CatCollectionStore.swift
//  catswithhats
//

import Foundation
import Observation

private let maxRerolls = 3

private let mockCards: [Card] = [
    Card(id: "astronaut",   name: "Astronaut Cat",    description: "One small step for cat, one giant leap for catkind.",         assetID: "astronaut",   rarity: .common,   weight: 50),
    Card(id: "chef",        name: "Chef Cat",          description: "Whisking danger with every flick of the tail.",               assetID: "chef",        rarity: .common,   weight: 50),
    Card(id: "farmer",      name: "Farmer Cat",        description: "Rises at 5am. Not for chores — for the sunrise nap.",        assetID: "farmer",      rarity: .common,   weight: 50),
    Card(id: "pilot",       name: "Pilot Cat",         description: "Cleared for takeoff, pending treat confirmation.",            assetID: "pilot",       rarity: .common,   weight: 50),
    Card(id: "artist",      name: "Artist Cat",        description: "Every knock off the shelf is a deliberate composition.",      assetID: "artist",      rarity: .uncommon, weight: 25),
    Card(id: "detective",   name: "Detective Cat",     description: "Solving the mystery of where the treats went since 2024.",    assetID: "detective",   rarity: .uncommon, weight: 25),
    Card(id: "firefighter", name: "Firefighter Cat",   description: "First on the scene. Usually the one who started the chaos.", assetID: "firefighter", rarity: .uncommon, weight: 25),
    Card(id: "chef_2",      name: "Sous Chef Cat",     description: "Not the head chef. Refuses to accept this.",                 assetID: "chef_2",      rarity: .rare,     weight: 8),
    Card(id: "pirate",      name: "Pirate Cat",        description: "Sailing the seven seas in search of the perfect nap spot.",  assetID: "pirate",      rarity: .rare,     weight: 8),
    Card(id: "wizard",      name: "Wizard Cat",        description: "Ancient. Unknowable. Obsessed with cardboard boxes.",        assetID: "wizard",      rarity: .legendary, weight: 2),
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
