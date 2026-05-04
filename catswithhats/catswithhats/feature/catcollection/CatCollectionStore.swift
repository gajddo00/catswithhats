//
//  CatCollectionStore.swift
//  catswithhats
//

import Foundation
import Observation

private let maxRerolls = 3

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
            Task { await fetchPreview() }
        case .acceptCard:
            guard let card = state.freeCard else { return }
            state.freeCard = nil
            Task { await accept(card: card) }
        }
    }
}

private extension CatCollectionStore {
    func load() async {
        state.isLoading = true
        state.errorMessage = nil
        defer { state.isLoading = false }
        do {
            async let allCards = databaseService.fetchCards()
            async let userCards = databaseService.fetchUserCards(userID: userID)
            let (cards, owned) = try await (allCards, userCards)

            state.availableCards = cards
            let ownedIDs = Set(owned.map(\.cardID))
            state.ownedCards = cards.filter { ownedIDs.contains($0.id) }

            if state.ownedCards.isEmpty {
                state.freeCard = try await databaseService.getRandomCardPreview(userID: userID)
                state.rerollsRemaining = maxRerolls
            }
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }

    func fetchPreview() async {
        do {
            state.freeCard = try await databaseService.getRandomCardPreview(userID: userID)
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }

    func accept(card: Card) async {
        do {
            try await databaseService.assignCard(userID: userID, cardID: card.id)
            state.ownedCards.append(card)
        } catch {
            state.freeCard = card
            state.errorMessage = error.localizedDescription
        }
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
