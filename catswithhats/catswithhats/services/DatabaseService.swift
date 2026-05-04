//
//  DatabaseService.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import FirebaseFirestore
import Foundation

protocol DatabaseService {
    func createUserIfNeeded(id: String, name: String) async throws
    func fetchUser(id: String) async throws -> User?
    func fetchUser(name: String) async throws -> User?
    func fetchCards() async throws -> [Card]
    func fetchUserCards(userID: String) async throws -> [UserCard]
    func seedCardsIfNeeded() async throws
    func drawRandomCard(userID: String) async throws -> Card
    func spendTokens(userID: String, amount: Int) async throws
    func addTokens(userID: String, amount: Int) async throws
}

enum DatabaseError: LocalizedError {
    case usernameTaken
    case noCardsAvailable
    case insufficientTokens

    var errorDescription: String? {
        switch self {
        case .usernameTaken:
            String(localized: "error_username_taken")
        case .noCardsAvailable:
            "No cards available to draw."
        case .insufficientTokens:
            "Not enough tokens."
        }
    }
}

final class FirebaseDatabaseService: DatabaseService {
    private let usersScheme = "users"
    private let cardsScheme = "cards"
    private let userCardsScheme = "user_cards"

    private var firestore: Firestore { Firestore.firestore() }

    func createUserIfNeeded(id: String, name: String) async throws {
        let ref = firestore.collection(usersScheme).document(id)
        let snapshot = try await ref.getDocument()
        guard !snapshot.exists else { return }

        if try await fetchUser(name: name) != nil {
            throw DatabaseError.usernameTaken
        }

        let user = User(id: id, name: name, createdAt: Date(), tokens: 50)
        try ref.setData(from: user)
    }

    func fetchUser(id: String) async throws -> User? {
        let snapshot = try await firestore.collection(usersScheme).document(id).getDocument()
        guard snapshot.exists else { return nil }
        return try snapshot.data(as: User.self)
    }

    func fetchUser(name: String) async throws -> User? {
        let snapshot = try await firestore
            .collection(usersScheme)
            .whereField("name", isEqualTo: name)
            .limit(to: 1)
            .getDocuments()
        return try snapshot.documents.first?.data(as: User.self)
    }

    func fetchCards() async throws -> [Card] {
        let snapshot = try await firestore.collection(cardsScheme).getDocuments()
        return try snapshot.documents.map { try $0.data(as: Card.self) }
    }

    func fetchUserCards(userID: String) async throws -> [UserCard] {
        let snapshot = try await firestore
            .collection(userCardsScheme)
            .whereField("user_id", isEqualTo: userID)
            .getDocuments()
        return try snapshot.documents.map { try $0.data(as: UserCard.self) }
    }

    func spendTokens(userID: String, amount: Int) async throws {
        let ref = firestore.collection(usersScheme).document(userID)
        let snapshot = try await ref.getDocument()
        let user = try snapshot.data(as: User.self)
        guard (user.tokens ?? 0) >= amount else {
            throw DatabaseError.insufficientTokens
        }
        try await ref.updateData([
            "tokens": FieldValue.increment(Int64(-amount))
        ])
    }

    func addTokens(userID: String, amount: Int) async throws {
        let ref = firestore.collection(usersScheme).document(userID)
        try await ref.updateData([
            "tokens": FieldValue.increment(Int64(amount))
        ])
    }

    func drawRandomCard(userID: String) async throws -> Card {
        let cards = try await fetchCards()
        guard let picked = pickWeightedRandom(from: cards) else {
            throw DatabaseError.noCardsAvailable
        }
        try await assignCard(userID: userID, cardID: picked.id)
        return picked
    }

    func seedCardsIfNeeded() async throws {
        let collection = firestore.collection(cardsScheme)
        let snapshot = try await collection.limit(to: 1).getDocuments()
        guard snapshot.documents.isEmpty else { return }

        let batch = firestore.batch()
        for image in CatImage.allCases {
            let card = Card(
                id: image.rawValue,
                name: image.displayName,
                assetID: image.rawValue,
                rarity: image.seedRarity,
                weight: image.seedWeight
            )
            try batch.setData(from: card, forDocument: collection.document(card.id))
        }
        try await batch.commit()
    }
}

private extension FirebaseDatabaseService {
    func pickWeightedRandom(from cards: [Card]) -> Card? {
        let pool = cards.filter { $0.weight > 0 }
        guard !pool.isEmpty else { return nil }
        let totalWeight = pool.reduce(0) { $0 + $1.weight }
        var roll = Int.random(in: 0..<totalWeight)
        for card in pool {
            roll -= card.weight
            if roll < 0 { return card }
        }
        return pool.last
    }

    func assignCard(userID: String, cardID: String) async throws {
        let docID = "\(userID)_\(cardID)"
        let ref = firestore.collection(userCardsScheme).document(docID)
        let snapshot = try await ref.getDocument()

        if snapshot.exists {
            try await ref.updateData([
                "quantity": FieldValue.increment(Int64(1))
            ])
        } else {
            let userCard = UserCard(
                id: docID,
                userID: userID,
                cardID: cardID,
                quantity: 1,
                acquiredAt: Date()
            )
            try ref.setData(from: userCard)
        }
    }
}

private extension CatImage {
    var seedRarity: Rarity {
        switch self {
        case .astronaut, .chef, .farmer, .pilot: .common
        case .artist, .detective, .firefighter: .uncommon
        case .chef2, .pirate: .rare
        case .wizard: .legendary
        }
    }

    var seedWeight: Int {
        switch seedRarity {
        case .common: 50
        case .uncommon: 25
        case .rare: 8
        case .legendary: 2
        }
    }
}
