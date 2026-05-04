//
//  StickerButtonStyle.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import SwiftUI

struct StickerButtonStyle: ButtonStyle {
    var fillColor: Color = .cPink
    var cornerRadius: Spacing = .regular

    func makeBody(configuration: Configuration) -> some View {
        StickerButtonBody(
            configuration: configuration,
            fillColor: fillColor,
            cornerRadius: cornerRadius
        )
    }
}

extension ButtonStyle where Self == StickerButtonStyle {
    static var sticker: StickerButtonStyle { StickerButtonStyle() }
}

private struct StickerButtonBody: View {
    @Environment(\.isEnabled) private var isEnabled

    let configuration: ButtonStyle.Configuration
    let fillColor: Color
    let cornerRadius: Spacing

    var body: some View {
        let pressed = configuration.isPressed
        configuration.label
            .font(.system(size: 22, weight: .black))
            .foregroundStyle(Color.cInk)
            .opacity(isEnabled ? 1.0 : 0.4)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(fillColor)
            .stickerStyle(
                cornerRadius: cornerRadius,
                lineWidth: 3,
                shadowOffset: pressed ? 2 : 6
            )
            .offset(x: pressed ? 2 : 0, y: pressed ? 2 : 0)
            .animation(.easeOut(duration: 0.08), value: pressed)
            .animation(.easeOut(duration: 0.15), value: isEnabled)
    }
}
