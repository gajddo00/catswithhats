//
//  PaywallStore.swift
//  catswithhats
//

import Foundation
import Observation

struct PackageInfo: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let price: String
    let icon: String
    let package: Any?
    
    init(id: String, title: String, subtitle: String, price: String, icon: String, package: Any? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.icon = icon
        self.package = package
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PackageInfo, rhs: PackageInfo) -> Bool {
        lhs.id == rhs.id
    }
}

@Observable
final class PaywallStore: Store {
    private(set) var state = State()
    
    init() {
        loadPackages()
    }
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            break
        case .selectPackage(let package):
            state.selectedPackage = package
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
    func loadPackages() {
        // Mock data matching the screenshot design
        state.packages = [
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
    }
    
    func purchase() async {
        guard let selectedPackage = state.selectedPackage else {
            return
        }
        
        state.isPurchasing = true
        
        // TODO: Implement actual RevenueCat purchase
        // For now, just simulate a delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        state.isPurchasing = false
    }
    
    func restore() async {
        // TODO: Implement actual RevenueCat restore
        try? await Task.sleep(nanoseconds: 1_000_000_000)
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
        var packages: [PackageInfo] = []
        var selectedPackage: PackageInfo?
        var isPurchasing: Bool = false
        var hasActiveSubscription: Bool = false
    }
}
