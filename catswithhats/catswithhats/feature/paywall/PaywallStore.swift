//
//  PaywallStore.swift
//  catswithhats
//

import Foundation
import Observation
import RevenueCat

struct PackageInfo: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let price: String
    let icon: String
    let tokens: Int
    let package: Package?

    init(
        id: String,
        title: String,
        subtitle: String,
        price: String,
        icon: String,
        tokens: Int,
        package: Package? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.icon = icon
        self.tokens = tokens
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
    private let databaseService: any DatabaseService
    private let userID: String
    private let onCoinsChanged: (() -> Void)?

    init(
        databaseService: any DatabaseService,
        userID: String,
        onCoinsChanged: (() -> Void)? = nil
    ) {
        self.databaseService = databaseService
        self.userID = userID
        self.onCoinsChanged = onCoinsChanged
    }

    func send(_ action: Action) {
        switch action {
        case .onAppear:
            Task { await loadPackages() }
        case .selectPackage(let package):
            state.selectedPackage = package
        case .purchase:
            Task { await purchase() }
        case .restorePurchases:
            Task { await restore() }
        case .dismiss:
            break
        }
    }
}

private extension PaywallStore {
    func loadPackages() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            guard let current = offerings.current else {
                state.packages = []
                return
            }
            state.packages = current.availablePackages.map(packageInfo(from:))
            state.selectedPackage = state.packages.first
        } catch {
            // surface later
        }
    }

    func purchase() async {
        guard let info = state.selectedPackage,
              let pkg = info.package else { return }
        state.isPurchasing = true
        defer { state.isPurchasing = false }
        do {
            let result = try await Purchases.shared.purchase(package: pkg)
            guard !result.userCancelled else { return }
            try await databaseService.addTokens(userID: userID, amount: info.tokens)
            onCoinsChanged?()
        } catch {
            // surface later
        }
    }

    func restore() async {
        _ = try? await Purchases.shared.restorePurchases()
    }

    func packageInfo(from package: Package) -> PackageInfo {
        let tokens = tokensFor(package: package)
        return PackageInfo(
            id: package.identifier,
            title: package.storeProduct.localizedTitle,
            subtitle: "\(tokens) Tokens",
            price: package.storeProduct.localizedPriceString,
            icon: iconFor(tokens: tokens),
            tokens: tokens,
            package: package
        )
    }

    func tokensFor(package: Package) -> Int {
        let id = package.identifier.lowercased()
        if id.contains("starter") { return 50 }
        if id.contains("bucket") || id.contains("medium") { return 250 }
        if id.contains("golden") || id.contains("large") { return 500 }
        let price = package.storeProduct.priceDecimalNumber.doubleValue
        if price < 1.5 { return 50 }
        if price < 10 { return 250 }
        return 500
    }

    func iconFor(tokens: Int) -> String {
        switch tokens {
        case ..<100: "🎁"
        case ..<300: "🪣"
        default: "📦"
        }
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
