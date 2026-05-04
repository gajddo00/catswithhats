//
//  GachaStore.swift
//  catswithhats
//

import Foundation
import Observation

@Observable
final class GachaStore: Store {
    private(set) var state = State()
    private let databaseService: any DatabaseService
    private let userID: String

    init(databaseService: any DatabaseService, userID: String) {
        self.databaseService = databaseService
        self.userID = userID
    }

    func send(_ action: Action) {
        switch action {
        case .onAppear:
            Task { await load() }

        case .spinTapped:
            guard case .content(let s) = state.uiState, !s.isSpinning else { return }
            Task { await spin() }

        case .dismissResult:
            updateContent { $0.phase = .idle }
        }
    }
}

private extension GachaStore {
    func load() async {
        if case .content = state.uiState { return }
        state.uiState = .loading
        do {
            let user = try await databaseService.fetchUser(id: userID)
            state.uiState = .content(GachaState(user: user))
        } catch {
            state.uiState = .error(error.localizedDescription)
        }
    }

    func spin() async {
        updateContent { $0.phase = .spinning }

        let drawTask = Task<Card, Error> {
            try await databaseService.drawRandomCard(userID: userID)
        }
        try? await Task.sleep(for: .seconds(1.5))

        do {
            let card = try await drawTask.value
            updateContent { $0.phase = .result(card) }
        } catch {
            updateContent { $0.phase = .idle }
        }
    }

    func updateContent(_ mutate: (inout GachaState) -> Void) {
        guard case .content(var s) = state.uiState else { return }
        mutate(&s)
        state.uiState = .content(s)
    }
}

extension GachaStore {
    enum Action {
        case onAppear
        case spinTapped
        case dismissResult
    }

    struct State {
        var uiState: UiState<GachaState> = .loading
    }
}
