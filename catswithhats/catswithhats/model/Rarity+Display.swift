//
//  Rarity+Display.swift
//  catswithhats
//

import SwiftUI

extension Rarity {
    var displayName: String {
        switch self {
        case .common: "COMMON"
        case .uncommon: "UNCOMMON"
        case .rare: "RARE"
        case .legendary: "LEGENDARY"
        }
    }

    var badgeColor: Color {
        switch self {
        case .common: Color.Theme.secondaryContainer
        case .uncommon: Color.Theme.rarityLavender
        case .rare: Color.Theme.rarityGold
        case .legendary: Color.Theme.primaryContainer
        }
    }
}
