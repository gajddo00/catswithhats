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
    let rcPackage: Package?
    
    init(id: String, title: String, subtitle: String, price: String, icon: String, rcPackage: Package? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.icon = icon
        self.rcPackage = rcPackage
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
        Task {
            await loadPackages()
        }
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
            // Handle dismiss - parent view should handle this
            break
        }
    }
}

private extension PaywallStore {
    func loadPackages() async {
        state.isLoading = true
        
        do {
            let offerings = try await Purchases.shared.offerings()
            
            guard let currentOffering = offerings.current,
                  !currentOffering.availablePackages.isEmpty else {
                // Fall back to mock data if no offerings available
                loadMockPackages()
                state.isLoading = false
                return
            }
            
            // Map RevenueCat packages to our PackageInfo
            state.packages = currentOffering.availablePackages.enumerated().map { index, package in
                let icon = iconForPackage(at: index, packageType: package.packageType)
                
                return PackageInfo(
                    id: package.identifier,
                    title: titleForPackage(package),
                    subtitle: subtitleForPackage(package),
                    price: package.storeProduct.localizedPriceString,
                    icon: icon,
                    rcPackage: package
                )
            }
            
            state.isLoading = false
        } catch {
            print("Error loading offerings: \(error)")
            // Fall back to mock data on error
            loadMockPackages()
            state.isLoading = false
        }
    }
    
    func loadMockPackages() {
        // Mock data matching the screenshot design (for testing without RevenueCat setup)
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
    
    func titleForPackage(_ package: Package) -> String {
        // Extract title from product display name or use package type
        let displayName = package.storeProduct.localizedTitle
        if !displayName.isEmpty {
            return displayName
        }
        
        switch package.packageType {
        case .lifetime: return "Lifetime"
        case .annual: return "Annual"
        case .sixMonth: return "6 Months"
        case .threeMonth: return "3 Months"
        case .twoMonth: return "2 Months"
        case .monthly: return "Monthly"
        case .weekly: return "Weekly"
        default: return package.identifier
        }
    }
    
    func subtitleForPackage(_ package: Package) -> String {
        // Use the product description or create a subtitle based on type
        let description = package.storeProduct.localizedDescription
        if !description.isEmpty {
            return description
        }
        
        switch package.packageType {
        case .lifetime: return "One-time purchase"
        case .annual: return "Best value"
        case .monthly: return "Billed monthly"
        case .weekly: return "Billed weekly"
        default: return "In-app purchase"
        }
    }
    
    func iconForPackage(at index: Int, packageType: PackageType) -> String {
        // Map package types to icons
        switch packageType {
        case .lifetime: return "📦"
        case .annual: return "🎁"
        case .monthly: return "🪣"
        case .weekly: return "🎉"
        default:
            // Use index-based icons if type doesn't match
            let icons = ["🎁", "🪣", "📦", "🎉", "🌟"]
            return icons[min(index, icons.count - 1)]
        }
    }
    
    func purchase() async {
        guard let selectedPackage = state.selectedPackage,
              let rcPackage = selectedPackage.rcPackage else {
            return
        }
        
        state.isPurchasing = true
        
        do {
            let result = try await Purchases.shared.purchase(package: rcPackage)
            
            // Check if the user successfully purchased
            if !result.userCancelled {
                // Purchase successful
                print("Purchase successful: \(result.customerInfo)")
                // You can check entitlements here if needed
                // if result.customerInfo.entitlements["pro"]?.isActive == true { ... }
            }
            
            state.isPurchasing = false
        } catch {
            print("Purchase failed: \(error)")
            state.isPurchasing = false
            state.errorMessage = error.localizedDescription
        }
    }
    
    func restore() async {
        state.isLoading = true
        
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            print("Purchases restored: \(customerInfo)")
            
            // Reload packages to refresh state
            await loadPackages()
        } catch {
            print("Restore failed: \(error)")
            state.isLoading = false
            state.errorMessage = error.localizedDescription
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
        var isLoading: Bool = false
        var hasActiveSubscription: Bool = false
        var errorMessage: String?
    }
}
