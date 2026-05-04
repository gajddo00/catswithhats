//
//  StickerStyle.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import SwiftUI

struct StickerStyle<S: InsettableShape>: ViewModifier {
    let shape: S
    var lineWidth: CGFloat = 3
    var shadowOffset: CGFloat = 6

    func body(content: Content) -> some View {
        content
            .clipShape(shape)
            .overlay(shape.stroke(Color.cInk, lineWidth: lineWidth))
            .shadow(color: Color.cInk, radius: 0, x: shadowOffset, y: shadowOffset)
    }
}

extension View {
    func stickerStyle<S: InsettableShape>(
        _ shape: S,
        lineWidth: CGFloat = 3,
        shadowOffset: CGFloat = 6
    ) -> some View {
        modifier(StickerStyle(shape: shape, lineWidth: lineWidth, shadowOffset: shadowOffset))
    }

    func stickerStyle(
        cornerRadius: Spacing = .regular,
        lineWidth: CGFloat = 3,
        shadowOffset: CGFloat = 6
    ) -> some View {
        stickerStyle(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            lineWidth: lineWidth,
            shadowOffset: shadowOffset
        )
    }
}
