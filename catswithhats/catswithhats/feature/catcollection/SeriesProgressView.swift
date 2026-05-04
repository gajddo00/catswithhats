//
//  SeriesProgressView.swift
//  catswithhats
//

import SwiftUI

struct SeriesProgressView: View {
    let ownedCount: Int
    let totalCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: .regular) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: .min) {
                    Text("Series 01")
                        .font(Font.Theme.headlineLg)
                    Text("URBAN EXPLORERS")
                        .font(Font.Theme.labelSm)
                        .opacity(0.8)
                        .kerning(1.5)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: .min) {
                    Text("\(ownedCount) / \(totalCount)")
                        .font(Font.Theme.headlineXL)
                    Text("COLLECTED")
                        .font(Font.Theme.labelSm)
                        .opacity(0.8)
                        .kerning(1.5)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white)
                        .overlay { Capsule().stroke(Color.Theme.ink, lineWidth: 3) }
                    if totalCount > 0 {
                        Capsule()
                            .fill(Color.Theme.primaryContainer)
                            .frame(width: geo.size.width * CGFloat(ownedCount) / CGFloat(totalCount))
                    }
                }
            }
            .frame(height: 24)
        }
        .foregroundStyle(Color(hex: "#326c41"))
        .padding(.regular)
        .background(Color.Theme.tertiaryContainer)
        .clipShape(RoundedRectangle(cornerRadius: .large, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: .large, style: .continuous)
                .stroke(Color.Theme.ink, lineWidth: 3)
        }
        .blockShadow(offsetX: 6, offsetY: 6, cornerRadius: Spacing.large.rawValue)
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color.Theme.ink.opacity(0.15))
                .rotationEffect(.degrees(12))
                .offset(x: 8, y: 8)
                .clipped()
        }
    }
}
