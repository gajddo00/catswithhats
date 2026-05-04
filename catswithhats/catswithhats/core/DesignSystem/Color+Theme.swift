//
//  Color+Theme.swift
//  catswithhats
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }

    enum Theme {
        // Brand
        static let primary = Color(hex: "#78555e")
        static let primaryContainer = Color(hex: "#ffd1dc")
        static let onPrimaryContainer = Color(hex: "#7a5761")
        static let secondary = Color(hex: "#625f4e")
        static let secondaryContainer = Color(hex: "#e8e3cd")
        static let tertiary = Color(hex: "#2f6a3f")
        static let tertiaryContainer = Color(hex: "#acecb5")

        // Surface
        static let background = Color(hex: "#fffdd0")
        static let surface = Color(hex: "#fcf9f8")
        static let surfaceContainerLow = Color(hex: "#f6f3f2")
        static let surfaceContainer = Color(hex: "#f0eded")

        // Content
        static let onSurface = Color(hex: "#1b1c1c")
        static let onSurfaceVariant = Color(hex: "#4f4446")
        static let outline = Color(hex: "#817476")
        static let outlineVariant = Color(hex: "#d3c3c5")

        // Semantic
        static let error = Color(hex: "#ba1a1a")
        static let errorContainer = Color(hex: "#ffdad6")

        // Fixed palette (used for card backgrounds)
        static let primaryFixed = Color(hex: "#ffd9e2")
        static let primaryFixedDim = Color(hex: "#e7bbc6")

        // Custom
        static let ink = Color(hex: "#1b1c1c")
        static let rarityLavender = Color(hex: "#d1d1ff")
        static let rarityGold = Color(hex: "#ffd700")
        static let tabBar = Color.white

        // Card background palette — deterministic pick via card ID hash
        static let cardBackgrounds: [Color] = [
            primaryFixed,
            tertiaryContainer,
            secondaryContainer,
            primaryFixedDim,
        ]
    }
}
