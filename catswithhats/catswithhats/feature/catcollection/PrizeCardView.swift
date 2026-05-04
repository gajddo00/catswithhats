//
//  PrizeCardView.swift
//  catswithhats
//

import SwiftUI

struct PrizeCardView: View {
    let card: Card

    var body: some View {
        VStack(spacing: .regular) {
            RarityBadgeView(rarity: card.rarity)

            // Cat image
            ZStack {
                Color.Theme.primaryContainer
                Image(card.assetID) // asset in Assets/cats/<assetID>
                    .resizable()
                    .scaledToFit()
                    .padding(.regular)
            }
            .aspectRatio(1.3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: .mid, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: .mid, style: .continuous)
                    .stroke(Color.Theme.ink, lineWidth: 3)
            }
            .blockShadow(offsetX: 3, offsetY: 3, cornerRadius: Spacing.mid.rawValue)

            Text(card.name)
                .font(Font.Theme.headlineXL)
                .foregroundStyle(Color.Theme.ink)
                .multilineTextAlignment(.center)

            if let description = card.description {
                Text(description)
                    .font(Font.Theme.bodyMd)
                    .italic()
                    .foregroundStyle(Color.Theme.onSurfaceVariant)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .small)
            }
        }
        .padding(.regular)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: .extraLarge, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: .extraLarge, style: .continuous)
                .stroke(Color.Theme.ink, lineWidth: 3)
        }
        .blockShadow(offsetX: 8, offsetY: 8, cornerRadius: Spacing.extraLarge.rawValue)
        .rotationEffect(.degrees(-2))
        .overlay(alignment: .topTrailing) {
            StarburstBadgeView()
                .offset(x: 20, y: -20)
        }
    }
}
