//
//  PaywallState.swift
//  catswithhats
//

struct PaywallState {
    var packages: [PackageInfo] = []
    var selectedPackage: PackageInfo?
    var isPurchasing: Bool = false
    var hasActiveSubscription: Bool = false
}

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
