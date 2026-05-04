//
//  Colors.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import SwiftUI

extension Color {
    static let cPink = Color("BackgroundPink")
    static let cInk = Color("Ink")
    static let cMint = Color("MintChip")
    static let cBlue = Color("BlueChip")
    static let cField = Color("InputField")
    static let cSubtitle = Color("SubtitleText")
}

#if canImport(UIKit)
import UIKit

extension UIColor {
    static let cPink = UIColor(named: "BackgroundPink")!
    static let cInk = UIColor(named: "Ink")!
    static let cMint = UIColor(named: "MintChip")!
    static let cBlue = UIColor(named: "BlueChip")!
    static let cField = UIColor(named: "InputField")!
    static let cSubtitle = UIColor(named: "SubtitleText")!
}
#endif
