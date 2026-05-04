//
//  UserCard.swift
//  catswithhats
//
//  Created by Dominika Gajdová on 04.05.2026.
//

import Foundation

struct UserCard: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var userID: String
    var cardID: String
    var quantity: Int
    var acquiredAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cardID = "card_id"
        case quantity
        case acquiredAt
    }
}
