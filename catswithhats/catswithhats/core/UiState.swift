//
//  UiState.swift
//  catswithhats
//

enum UiState<T> {
    case loading
    case error(String)
    case content(T)
}
