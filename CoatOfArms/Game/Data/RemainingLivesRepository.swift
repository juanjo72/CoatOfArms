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

    private let game: GameStamp
    private let storage: any StorageProtocol
    
    // MARK: RemainingLivesRepositoryProtocol
    
    var wrongAnswers: AnyPublisher<[UserChoice], Never> {
        self.storage.getAllElementsObservable(of: UserChoice.self)
            .map { $0.filter { $0.id.game == self.game } }
            .map { $0.filter { !$0.isCorrect } }
            .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        game: GameStamp,
        storage: any StorageProtocol
    ) {
        self.game = game
        self.storage = storage
    }
}
