//
// LivesRepository.swift
// CoatOfArms
//
// Created on 2/9/24
    

import Combine
import ReactiveStorage

protocol RemainingLivesRepositoryProtocol {
    var wrongAnswers: AnyPublisher<[UserChoice], Never> { get }
}

/// Remaining lives view's data layer
struct RemainingLivesRepository: RemainingLivesRepositoryProtocol {
    
    // MARK: Injected

    private let game: GameStamp
    private let storage: any ReactiveStorageProtocol
    
    // MARK: RemainingLivesRepositoryProtocol
    
    var wrongAnswers: AnyPublisher<[UserChoice], Never> {
        self.storage.getAllElementsObservable(of: UserChoice.self)
            .map { $0.filter { [self] in $0.game == self.game }}
            .map { $0.filter { !$0.isCorrect } }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        game: GameStamp,
        storage: any ReactiveStorageProtocol
    ) {
        self.game = game
        self.storage = storage
    }
}
