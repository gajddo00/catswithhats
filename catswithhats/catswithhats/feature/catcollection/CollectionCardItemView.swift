//
//  CollectionCardItemView.swift
//  catswithhats
//

import SwiftUI

struct CollectionCardItemView: View {
    let card: Card
    let isOwned: Bool

    var body: some View {
        VStack(spacing: .small) {
            ZStack {
                if isOwned {
                    ownedCircle
                } else {
                    lockedCircle
                }
            }
            Text(isOwned ? card.name : "Locked")
                .font(Font.Theme.labelSm)
                .foregroundStyle(isOwned ? Color.Theme.onSurface : Color.Theme.outline)
                .lineLimit(1)
        }
    }

    private var ownedCircle: some View {
        Circle()
            .fill(cardBackground)
            .overlay {
                Image(card.assetID)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .padding(Spacing.regular.rawValue * 0.5)
            }
            .overlay { Circle().stroke(Color.Theme.ink, lineWidth: 3) }
            .blockShadow(offsetX: 4, offsetY: 4, cornerRadius: .infinity)
            .overlay(alignment: .topTrailing) {
                RarityBadgeView(rarity: card.rarity)
                    .scaleEffect(0.85)
                    .rotationEffect(.degrees(badgeRotation))
                    .offset(x: 4, y: 4)
            }
    }

    private var lockedCircle: some View {
        Circle()
            .fill(Color.Theme.surfaceContainer)
            .overlay {
                ZStack {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.Theme.outline.opacity(0.4))
                    Text("?")
                        .font(.system(size: 28, weight: .black))
                        .foregroundStyle(Color.Theme.ink)
                        .shadow(color: .white, radius: 0, x: 2, y: 2)
                }
            }
            .overlay {
                Circle()
                    .stroke(Color.Theme.ink.opacity(0.5), style: StrokeStyle(lineWidth: 3, dash: [8, 4]))
            }
            .opacity(0.7)
            .grayscale(1)
    }

    // Deterministic background and badge rotation derived from card ID
    private var cardBackground: Color {
        let index = abs(card.id.hashValue) % Color.Theme.cardBackgrounds.count
        return Color.Theme.cardBackgrounds[index]
    }

    private var badgeRotation: Double {
        let rotations: [Double] = [12, -12, 6, -6, 15, -8]
        return rotations[abs(card.id.hashValue) % rotations.count]
    }
}
