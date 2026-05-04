//
//  Card.swift
//  catswithhats
//
//  Created by Dominika Gajdová on 04.05.2026.
//

import Foundation

struct Card: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var name: String
    var assetID: String
    var rarity: Rarity
    var weight: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case assetID = "asset_id"
        case rarity
        case weight
    }
}

enum Rarity: String, Codable, Hashable, CaseIterable, Sendable {
    case common
    case uncommon
    case rare
    case legendary
}
