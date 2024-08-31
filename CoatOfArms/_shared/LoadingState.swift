//
//  LoadingState.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 31/8/24.
//

/// Different loading states of a view
enum LoadingState<Element> {
    case idle
    case loading
    case loaded(Element)
}

extension LoadingState {
    var element: Element? {
        return switch self {
        case .loaded(let view):
            view
        case .idle, .loading:
            nil
        }
    }
}
