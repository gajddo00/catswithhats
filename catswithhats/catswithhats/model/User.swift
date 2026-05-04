//
//  User.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import Foundation

struct User: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var name: String
    var createdAt: Date
}
