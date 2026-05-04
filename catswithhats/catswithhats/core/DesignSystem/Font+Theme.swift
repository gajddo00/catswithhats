//
//  Font+Theme.swift
//  catswithhats
//
//  Requires Plus Jakarta Sans to be bundled in the Xcode project.
//  Add the font files and declare them under UIAppFonts in Info.plist.
//

import SwiftUI

extension Font {
    enum Theme {
        static let headlineXL = Font.custom("PlusJakartaSans-ExtraBold", size: 32)
        static let headlineLg = Font.custom("PlusJakartaSans-ExtraBold", size: 24)
        static let bodyMd = Font.custom("PlusJakartaSans-Medium", size: 16)
        static let labelSm = Font.custom("PlusJakartaSans-Bold", size: 13)
    }
}
