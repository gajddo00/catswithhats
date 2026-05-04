//
//  Store.swift
//  catswithhats
//
//  Created by Dominika Gajdová on 04.05.2026.
//

import SwiftUI

protocol Store: AnyObject {
    associatedtype State
    associatedtype Action

    var state: State { get }
    func send(_ action: Action)
}

extension Store {
    func binding<Value>(
        _ keyPath: KeyPath<State, Value>,
        action: @escaping (Value) -> Action
    ) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.send(action($0)) }
        )
    }
}
