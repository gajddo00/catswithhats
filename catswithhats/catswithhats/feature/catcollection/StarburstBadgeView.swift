//
//  StarburstBadgeView.swift
//  catswithhats
//

import SwiftUI

struct StarburstBadgeView: View {
    var body: some View {
        ZStack {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)
            Image(systemName: "star")
                .font(.system(size: 60, weight: .black))
                .foregroundStyle(Color.Theme.ink)
            Text("NEW!")
                .font(Font.Theme.labelSm)
                .italic()
                .foregroundStyle(Color.Theme.ink)
                .rotationEffect(.degrees(15))
        }
        .rotationEffect(.degrees(15))
    }
}
