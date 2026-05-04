//
//  CoinsBadgeView.swift
//  catswithhats
//

import SwiftUI

struct CoinsBadgeView: View {
    let coins: Int

    var body: some View {
        HStack(spacing: .min) {
            Image(systemName: "dollarsign.circle")
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(Color(hex: "#C8860A"))
            Text(coins.formatted())
                .font(Font.Theme.labelSm)
                .foregroundStyle(Color.Theme.ink)
        }
        .padding(.horizontal, .mid)
        .padding(.vertical, 6)
    }
}
