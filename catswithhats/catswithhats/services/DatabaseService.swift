//
//  DatabaseService.swift
//  catswithhats
//
//  Created by Dominika Gajdova on 04.05.2026.
//

import FirebaseFirestore
import Foundation

protocol DatabaseService {
    // Models and operations to be added later.
}

final class FirebaseDatabaseService: DatabaseService {
    private var firestore: Firestore { Firestore.firestore() }
}
