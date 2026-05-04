//
//  MainTabScreen.swift
//  catswithhats
//

import SwiftUI

enum AppTab {
    case gacha, collection, shop
}

struct MainTabScreen: View {
    let databaseService: any DatabaseService
    let userID: String

    @State private var store: MainTabStore
    @State private var selectedTab: AppTab = .gacha

    init(databaseService: any DatabaseService, userID: String) {
        self.databaseService = databaseService
        self.userID = userID
        _store = State(initialValue: MainTabStore(databaseService: databaseService, userID: userID))

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = UIColor(Color.Theme.primary)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                GachaScreen(
                    databaseService: databaseService,
                    userID: userID,
                    onCoinsChanged: { store.send(.refresh) }
                )
                .coinsToolbar(coins: store.state.coins)
            }
            .tabItem { Label("GACHA", systemImage: "wand.and.sparkles.inverse") }
            .tag(AppTab.gacha)

            NavigationStack {
                CatCollectionScreen(
                    databaseService: databaseService,
                    userID: userID,
                    onGetNewSticker: { selectedTab = .shop }
                )
                .coinsToolbar(coins: store.state.coins)
            }
            .tabItem { Label("COLLECTION", systemImage: "square.grid.2x2") }
            .tag(AppTab.collection)

            NavigationStack {
                ShopScreen(
                    databaseService: databaseService,
                    userID: userID,
                    onCoinsChanged: { store.send(.refresh) }
                )
                .coinsToolbar(coins: store.state.coins)
            }
            .tabItem { Label("SHOP", systemImage: "bag") }
            .tag(AppTab.shop)
        }
        .onAppear { store.send(.onAppear) }
    }
}
