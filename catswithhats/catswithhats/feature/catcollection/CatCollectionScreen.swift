//
//  CatCollectionScreen.swift
//  catswithhats
//

import SwiftUI

struct CatCollectionScreen: View {
    @State private var store: CatCollectionStore
    let onGetNewSticker: () -> Void

    init(databaseService: any DatabaseService, userID: String, onGetNewSticker: @escaping () -> Void) {
        _store = State(initialValue: CatCollectionStore(databaseService: databaseService, userID: userID))
        self.onGetNewSticker = onGetNewSticker
    }

    var body: some View {
        Group {
            if store.state.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = store.state.errorMessage {
                Text(error)
                    .foregroundStyle(Color.Theme.error)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if store.state.isEmpty {
                emptyStateView
            } else {
                collectionGridView
            }
        }
        .background(Color.Theme.surface.ignoresSafeArea())
        .onAppear { store.send(.onAppear) }
    }

    // MARK: - Empty state

    private var emptyStateView: some View {
        ScrollView {
            VStack(spacing: .large) {
                if let card = store.state.freeCard {
                    PrizeCardView(card: card)
                        .padding(.horizontal, .regular)
                        .padding(.top, .extraLarge)
                }

                Spacer(minLength: Spacing.large.rawValue)

                VStack(spacing: .small) {
                    Button("ADD TO COLLECTION") {
                        store.send(.acceptCard)
                    }
                    .buttonStyle(ChunkyButtonStyle(fillColor: Color.Theme.primaryContainer))

                    if store.state.rerollsRemaining > 0 {
                        Button("ROLL AGAIN (\(store.state.rerollsRemaining))") {
                            store.send(.reroll)
                        }
                        .buttonStyle(ChunkyButtonStyle(fillColor: .white))
                    }
                }
                .padding(.horizontal, .regular)
                .padding(.bottom, .extraLarge)
            }
        }
    }

    // MARK: - Collection grid

    private var collectionGridView: some View {
        let ownedIDs = Set(store.state.ownedCards.map(\.id))

        return ScrollView {
            VStack(spacing: .extraLarge) {
                SeriesProgressView(
                    ownedCount: store.state.ownedCards.count,
                    totalCount: store.state.availableCards.count
                )

                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: .large
                ) {
                    ForEach(store.state.availableCards) { card in
                        CollectionCardItemView(
                            card: card,
                            isOwned: ownedIDs.contains(card.id)
                        )
                    }
                }

                Button {
                    onGetNewSticker()
                } label: {
                    HStack(spacing: .small) {
                        Image(systemName: "sparkles")
                        Text("GET NEW STICKER")
                    }
                }
                .buttonStyle(ChunkyButtonStyle(fillColor: Color.Theme.primaryContainer))
            }
            .padding(.regular)
            .padding(.bottom, .extraLarge)
        }
    }
}
