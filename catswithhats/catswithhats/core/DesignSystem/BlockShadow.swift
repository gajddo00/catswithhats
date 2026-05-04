//
//  BlockShadow.swift
//  catswithhats
//

import SwiftUI

// Solid offset shadow that mimics the CSS `box-shadow: Xpx Ypx 0px 0px #000` sticker effect.
struct BlockShadowModifier: ViewModifier {
    let offsetX: CGFloat
    let offsetY: CGFloat
    let color: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.background(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(color)
                .offset(x: offsetX, y: offsetY)
        }
    }
}

extension View {
    func blockShadow(
        offsetX: CGFloat = 4,
        offsetY: CGFloat = 4,
        cornerRadius: CGFloat = 0,
        color: Color = Color.Theme.ink
    ) -> some View {
        modifier(BlockShadowModifier(offsetX: offsetX, offsetY: offsetY, color: color, cornerRadius: cornerRadius))
    }
}

struct ChunkyButtonStyle: ButtonStyle {
    var fillColor: Color = Color.Theme.primaryContainer

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        configuration.label
            .font(Font.Theme.headlineLg)
            .foregroundStyle(Color.Theme.ink)
            .padding(.vertical, Spacing.regular)
            .frame(maxWidth: .infinity)
            .background(fillColor)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.mid.rawValue, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: Spacing.mid.rawValue, style: .continuous)
                    .stroke(Color.Theme.ink, lineWidth: 3)
            }
            .blockShadow(
                offsetX: pressed ? 2 : 6,
                offsetY: pressed ? 2 : 6,
                cornerRadius: Spacing.mid.rawValue
            )
            .offset(x: pressed ? 4 : 0, y: pressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.08), value: pressed)
    }
}
