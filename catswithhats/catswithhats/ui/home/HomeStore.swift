//
//  HomeStore.swift
//  catswithhats
//

import Foundation

@Observable
final class HomeStore {
    private(set) var uiState: UiState<HomeState> = .loading

    private let databaseService: any DatabaseService

    init(databaseService: any DatabaseService) {
        self.databaseService = databaseService
    }

    func load() async {
        // TODO: fetch cats from databaseService
        uiState = .content(HomeState(cats: []))
    }

    func didTapCat(_ cat: Cat) {
        // TODO: handle cat tap (e.g. navigate to detail)
    }
}
