//
//  Spacing.swift
//  catswithhats
//
//  Created by Dominika Gajdová on 04.05.2026.
//

import Foundation
import SwiftUI

enum Spacing: CGFloat, Sendable {
    /// 0
    case zero = 0
    /// 4
    case min = 4
    /// 8
    case small = 8
    /// 10
    case ten = 10
    /// 12
    case mid = 12
    /// 16
    case regular = 16
    /// 24
    case large = 24
    /// 32
    case extraLarge = 32
    /// 999
    case superLarge = 999

    static prefix func - (spacing: Spacing) -> CGFloat {
        -spacing.rawValue
    }
}

extension View {
    func padding(_ spacing: Spacing) -> some View {
        padding(spacing.rawValue)
    }

    func padding(_ edges: Edge.Set, _ spacing: Spacing?) -> some View {
        padding(edges, spacing?.rawValue)
    }

    func contentPadding(_ edges: Edge.Set = .all) -> some View {
        padding(edges, .regular)
    }

    func scrollContentMargins(_ edges: Edge.Set = .bottom) -> some View {
        contentMargins(edges, 135)
    }

    func contentMargins(_ edges: Edge.Set = .all, _ spacing: Spacing?) -> some View {
        contentMargins(edges, spacing?.rawValue)
    }

    func listRowSpacing(_ spacing: Spacing) -> some View {
        listRowSpacing(spacing.rawValue)
    }
}

extension HStack {
    init(
        alignment: VerticalAlignment = .center,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            content: content
        )
    }
}

extension LazyHStack {
    init(
        alignment: VerticalAlignment = .center,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            pinnedViews: [],
            content: content
        )
    }
}

extension VStack {
    init(
        alignment: HorizontalAlignment = .center,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            content: content
        )
    }
}

extension LazyVStack {
    init(
        alignment: HorizontalAlignment = .center,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            pinnedViews: [],
            content: content
        )
    }
}

extension LazyVGrid {
    init(
        columns: [GridItem],
        alignment: HorizontalAlignment = .center,
        spacing: Spacing,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            columns: columns,
            alignment: alignment,
            spacing: spacing.rawValue,
            pinnedViews: pinnedViews,
            content: content
        )
    }
}

extension EdgeInsets {
    init(
        top: Spacing,
        leading: Spacing,
        bottom: Spacing,
        trailing: Spacing
    ) {
        self.init(
            top: top.rawValue,
            leading: leading.rawValue,
            bottom: bottom.rawValue,
            trailing: trailing.rawValue
        )
    }
}

extension Spacer {
    func width(_ spacing: Spacing?) -> some View {
        frame(width: spacing?.rawValue)
    }

    func height(_ spacing: Spacing?) -> some View {
        frame(height: spacing?.rawValue)
    }
}

extension RoundedRectangle {
    init(cornerRadius: Spacing, style: RoundedCornerStyle = .continuous) {
        self.init(cornerRadius: cornerRadius.rawValue, style: style)
    }
}

extension UnevenRoundedRectangle {
    init(
        topLeadingRadius: Spacing = .zero,
        bottomLeadingRadius: Spacing = .zero,
        bottomTrailingRadius: Spacing = .zero,
        topTrailingRadius: Spacing = .zero,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(
            topLeadingRadius: topLeadingRadius.rawValue,
            bottomLeadingRadius: bottomLeadingRadius.rawValue,
            bottomTrailingRadius: bottomTrailingRadius.rawValue,
            topTrailingRadius: topTrailingRadius.rawValue,
            style: style
        )
    }
}
