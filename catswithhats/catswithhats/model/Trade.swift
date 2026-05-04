//
//  Trade.swift
//  catswithhats
//
//  Created by Dominika Gajdová on 04.05.2026.
//

import Foundation

struct Trade: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var initiatorID: String
    var receiverID: String?
    var initiatorCardID: String
    var receiverCardID: String?
    var status: TradeStatus
    var createdAt: Date
    var expiresAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case initiatorID = "initiator_id"
        case receiverID = "receiver_id"
        case initiatorCardID = "initiator_card_id"
        case receiverCardID = "receiver_card_id"
        case status
        case createdAt
        case expiresAt
    }
}

enum TradeStatus: String, Codable, Hashable, Sendable {
    case pending
    case completed
    case cancelled
    case expired
}
