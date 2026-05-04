//
//  CoinsBadgeView.swift
//  catswithhats
//

import SwiftUI

struct CoinsBadgeView: View {
    let coins: Int

    var body: some View {
        HStack(spacing: .small) {
            Image(systemName: "creditcard.fill")
                .font(.subheadline)
            Text("\(coins)")
                .font(Font.Theme.labelSm)
        }
        .foregroundStyle(Color.Theme.ink)
    }
}
