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
        case .dismissPurchaseSuccess:
            state.showPurchaseSuccess = false
            state.purchasedPackageTitle = nil
        }
    }
}

private extension PaywallStore {
    func loadPackages() async {
        state.isLoading = true
        do {
            let offerings = try await Purchases.shared.offerings()
            guard let current = offerings.current,
                  !current.availablePackages.isEmpty else {
                loadMockPackages()
                state.isLoading = false
                return
            }
            state.packages = current.availablePackages.map(packageInfo(from:))
            state.selectedPackage = state.packages.first
            state.isLoading = false
        } catch {
            print("Error loading offerings: \(error)")
            loadMockPackages()
            state.isLoading = false
        }
    }

    func loadMockPackages() {
        state.packages = [
            PackageInfo(
                id: "starter_bag",
                title: "Starter Bag",
                subtitle: "50 Tokens",
                price: "$0.99",
                icon: "🎁",
                tokens: 50
            ),
            PackageInfo(
                id: "bucket_treats",
                title: "Bucket of Treats",
                subtitle: "250 Tokens",
                price: "$4.99",
                icon: "🪣",
                tokens: 250
            ),
            PackageInfo(
                id: "golden_crate",
                title: "Golden Crate",
                subtitle: "500 Tokens",
                price: "$14.99",
                icon: "📦",
                tokens: 500
            )
        ]
        state.selectedPackage = state.packages.first
    }

    func purchase() async {
        guard let info = state.selectedPackage else { return }
        state.isPurchasing = true
        state.errorMessage = nil
        defer { state.isPurchasing = false }

        // Mock package (no RC backing): simulate the purchase.
        guard let pkg = info.package else {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            do {
                try await databaseService.addTokens(userID: userID, amount: info.tokens)
                onCoinsChanged?()
                state.purchasedPackageTitle = info.title
                state.showPurchaseSuccess = true
            } catch {
                state.errorMessage = error.localizedDescription
            }
            return
        }

        // Real RC package.
        do {
            let result = try await Purchases.shared.purchase(package: pkg)
            guard !result.userCancelled else { return }
            try await databaseService.addTokens(userID: userID, amount: info.tokens)
            onCoinsChanged?()
            state.purchasedPackageTitle = info.title
            state.showPurchaseSuccess = true
        } catch {
            print("Purchase failed: \(error)")
            state.errorMessage = error.localizedDescription
        }
    }

    func restore() async {
        state.isLoading = true
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            print("Purchases restored: \(customerInfo)")
            await loadPackages()
        } catch {
            print("Restore failed: \(error)")
            state.isLoading = false
            state.errorMessage = error.localizedDescription
        }
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
        case dismissPurchaseSuccess
    }

    struct State {
        var packages: [PackageInfo] = []
        var selectedPackage: PackageInfo?
        var isPurchasing: Bool = false
        var isLoading: Bool = false
        var hasActiveSubscription: Bool = false
        var errorMessage: String?
        var showPurchaseSuccess: Bool = false
        var purchasedPackageTitle: String?
    }
}
