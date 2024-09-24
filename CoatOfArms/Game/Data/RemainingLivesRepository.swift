//
//  RemainingLivesRepository.swift
//  CoatOfArms
//
//  Created on 2/9/24.
//

import Combine

protocol RemainingLivesRepositoryProtocol {
    var wrongAnswers: AnyPublisher<[UserChoice], Never> { get }
}

/// Remaining lives view's data layer
struct RemainingLivesRepository: RemainingLivesRepositoryProtocol {
    
    // MARK: Injected

    private let gameStamp: GameStamp
    private let store: any StorageProtocol
    
    // MARK: RemainingLivesRepositoryProtocol
    
    var wrongAnswers: AnyPublisher<[UserChoice], Never> {
        self.store.getAllElementsObservable(of: UserChoice.self)
            .map { $0.filter { $0.id.gameStamp == self.gameStamp } }
            .map { $0.filter { !$0.isCorrect } }
            .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        gameStamp: GameStamp,
        store: any StorageProtocol
    ) {
        self.gameStamp = gameStamp
        self.store = store
    }
}

// MARK: - RemainingLivesRepositoryProtocolMock -


