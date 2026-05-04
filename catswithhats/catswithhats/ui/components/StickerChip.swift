//
//  StickerChip.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import SwiftUI

struct StickerChip: View {
    let icon: String
    let label: LocalizedStringKey
    let backgroundColor: Color
    var rotation: Double = 0

    var body: some View {
        HStack(spacing: .min) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .black))
            Text(label)
                .font(.system(size: 12, weight: .black))
                .textCase(.uppercase)
        }
        .foregroundStyle(Color.cInk)
        .padding(.horizontal, .mid)
        .padding(.vertical, 6)
        .background(backgroundColor)
        .stickerStyle(Capsule(), lineWidth: 2, shadowOffset: 4)
        .rotationEffect(.degrees(rotation))
    }
}
