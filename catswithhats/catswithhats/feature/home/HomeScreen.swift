//
//  HomeScreen.swift
//  catswithhats
//

import SwiftUI

struct HomeScreen: View {
    @State private var store: HomeStore

    init(databaseService: any DatabaseService) {
        _store = State(initialValue: HomeStore(databaseService: databaseService))
    }

    var body: some View {
        switch store.uiState {
        case .loading:
            ProgressView()
        case .error(let message):
            Text(message)
                .foregroundStyle(.red)
        case .content(let state):
            contentView(state)
        }
    }

    private func contentView(_ state: HomeState) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if state.cats.isEmpty {
                    Text("No cats yet")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                } else {
                    ForEach(state.cats) { cat in
                        NavigationLink(value: AppRoute.catDetail(cat)) {
                            Text(cat.name)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Cats with Hats")
        .task { await store.load() }
    }
}
