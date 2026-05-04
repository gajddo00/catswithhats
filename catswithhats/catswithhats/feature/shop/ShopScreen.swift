//
//  ShopScreen.swift
//  catswithhats
//

import SwiftUI

struct ShopScreen: View {
    let databaseService: any DatabaseService
    let userID: String
    let onCoinsChanged: (() -> Void)?

    init(
        databaseService: any DatabaseService,
        userID: String,
        onCoinsChanged: (() -> Void)? = nil
    ) {
        self.databaseService = databaseService
        self.userID = userID
        self.onCoinsChanged = onCoinsChanged
    }

    var body: some View {
        PaywallScreen(
            databaseService: databaseService,
            userID: userID,
            onCoinsChanged: onCoinsChanged
        )
    }
}
