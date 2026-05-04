//
//  PaywallStore.swift
//  catswithhats
//

import Foundation
import Observation

@Observable
final class PaywallStore: Store {
    private(set) var state = State()
    
    init() {}
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            Task { await load() }
        case .selectPackage(let package):
            state.contentState?.selectedPackage = package
        case .purchase:
            Task { await purchase() }
        case .restorePurchases:
            Task { await restore() }
        case .dismiss:
            // Handle dismiss - parent view should handle this
            break
        }
    }
}

private extension PaywallStore {
    func load() async {
        state.uiState = .loading
        
        // Mock data matching the screenshot design
        let packages = [
            PackageInfo(
                id: "starter_bag",
                title: "Starter Bag",
                subtitle: "50 Tokens",
                price: "$0.99",
                icon: "🎁"
            ),
            PackageInfo(
                id: "bucket_treats",
                title: "Bucket of Treats",
                subtitle: "250 Tokens",
                price: "$4.99",
                icon: "🪣"
            ),
            PackageInfo(
                id: "golden_crate",
                title: "Golden Crate",
                subtitle: "500 Tokens",
                price: "$14.99",
                icon: "📦"
            )
        ]
        
        state.uiState = .content(PaywallState(
            packages: packages,
            selectedPackage: nil,
            isPurchasing: false,
            hasActiveSubscription: false
        ))
    }
    
    func purchase() async {
        guard var contentState = state.contentState,
              let selectedPackage = contentState.selectedPackage else {
            return
        }
        
        contentState.isPurchasing = true
        state.uiState = .content(contentState)
        
        // TODO: Implement actual RevenueCat purchase
        // For now, just simulate a delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        contentState.isPurchasing = false
        state.uiState = .content(contentState)
    }
    
    func restore() async {
        state.uiState = .loading
        
        // TODO: Implement actual RevenueCat restore
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await load()
    }
}

extension PaywallStore {
    enum Action {
        case onAppear
        case selectPackage(PackageInfo)
        case purchase
        case restorePurchases
        case dismiss
    }
    
    struct State {
        var uiState: UiState<PaywallState> = .loading
        
        var contentState: PaywallState? {
            get {
                if case .content(let state) = uiState {
                    return state
                }
                return nil
            }
            set {
                if let newValue = newValue {
                    uiState = .content(newValue)
                }
            }
        }
    }
}
