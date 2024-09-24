//
//  LoadingState.swift
//  CoatOfArms
//
//  Created on 31/8/24.
//

/// Different loading states of a view
enum LoadingState<Element> {
    case idle
    case loading
    case loaded(Element)
}

extension LoadingState {
    var isLoading: Bool {
        return switch self {
        case .loading:
            true
        case .idle, .loaded:
            false
        }
    }
    
    var element: Element? {
        return switch self {
        case .loaded(let view):
            view
        case .idle, .loading:
            nil
        }
    }
}
