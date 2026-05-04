//
//  CoinsBadgeView.swift
//  catswithhats
//

import SwiftUI

struct CoinsBadgeView: View {
    let coins: Int

    var body: some View {
        HStack(spacing: .min) {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(.yellow)
            Text(coins.formatted())
                .font(Font.Theme.labelSm)
                .foregroundStyle(Color.Theme.ink)
        }
        .padding(.horizontal, .mid)
        .padding(.vertical, 6)
    }
}
