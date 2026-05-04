//
//  GachaState.swift
//  catswithhats
//

struct GachaState {
    var user: User?
    var phase: Phase = .idle
}

extension GachaState {
    enum Phase: Equatable {
        case idle
        case spinning
        case result(Card)
    }

    var tokens: Int { user?.tokens ?? 0 }

    var isSpinning: Bool {
        if case .spinning = phase { return true }
        return false
    }

    var drawnCard: Card? {
        if case .result(let card) = phase { return card }
        return nil
    }

    var canSpin: Bool { tokens >= GachaStore.spinCost && !isSpinning }
}
