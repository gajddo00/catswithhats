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
}

enum DatabaseError: LocalizedError {
    case usernameTaken

    var errorDescription: String? {
        switch self {
        case .usernameTaken:
            String(localized: "error_username_taken")
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

        let user = User(id: id, name: name, createdAt: Date())
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
}
