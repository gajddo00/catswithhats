//
//  Environment+Coins.swift
//  catswithhats
//

import SwiftUI

private struct CoinsKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

extension EnvironmentValues {
    var coins: Int {
        get { self[CoinsKey.self] }
        set { self[CoinsKey.self] = newValue }
    }
}

extension View {
    func coinsToolbar(coins: Int) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CoinsBadgeView(coins: coins)
            }
        }
    }
}
