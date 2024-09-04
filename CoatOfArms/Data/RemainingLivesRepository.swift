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

struct RemainingLivesRepository: RemainingLivesRepositoryProtocol {
    private let gameId: GameStamp
    private let storage: any ReactiveStorageProtocol
    
    var wrongAnswers: AnyPublisher<[UserChoice], Never> {
        self.storage.getAllElementsObservable(of: UserChoice.self)
            .map { $0.filter { !$0.isCorrect } }
            .eraseToAnyPublisher()
    }
    
    init(
        gameId: GameStamp,
        storage: any ReactiveStorageProtocol
    ) {
        self.gameId = gameId
        self.storage = storage
    }
}
