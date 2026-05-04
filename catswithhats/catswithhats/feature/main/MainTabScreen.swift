//
//  MainTabScreen.swift
//  catswithhats
//

import SwiftUI

struct MainTabScreen: View {
    let authService: any AuthService
    let databaseService: any DatabaseService

    var body: some View {
        TabView {
            NavigationStack {
                GachaScreen(
                    authService: authService,
                    databaseService: databaseService
                )
            }
            .tabItem {
                Label("GACHA", systemImage: "wand.and.sparkles.inverse")
            }

            NavigationStack {
                CatCollectionScreen(databaseService: databaseService)
            }
            .tabItem {
                Label("COLLECTION", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                ShopScreen(databaseService: databaseService)
            }
            .tabItem {
                Label("SHOP", systemImage: "bag")
            }
        }
    }
}
