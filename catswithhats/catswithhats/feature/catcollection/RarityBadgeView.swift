//
//  RarityBadgeView.swift
//  catswithhats
//

import SwiftUI

struct RarityBadgeView: View {
    let rarity: Rarity

    var body: some View {
        Text(rarity.displayName)
            .font(Font.Theme.labelSm)
            .foregroundStyle(Color.Theme.ink)
            .padding(.horizontal, .regular)
            .padding(.vertical, .min)
            .background(rarity.badgeColor)
            .clipShape(Capsule())
            .overlay { Capsule().stroke(Color.Theme.ink, lineWidth: 2) }
            .blockShadow(offsetX: 3, offsetY: 3, cornerRadius: Spacing.superLarge.rawValue)
    }
}
