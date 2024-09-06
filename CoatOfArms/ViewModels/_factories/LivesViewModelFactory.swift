//
// LivesViewModelFactory.swift
// CoatOfArms
//
// Created on 3/9/24
    

import ReactiveStorage

struct LivesViewModelFactory {
    private let gameId: GameStamp
    private let gameSettings: GameSettings
    private let storage: ReactiveStorageProtocol
    
    init(
        gameId: GameStamp,
        gameSettings: GameSettings,
        storage: ReactiveStorageProtocol
    ) {
        self.gameId = gameId
        self.gameSettings = gameSettings
        self.storage = storage
    }
    
    func make() -> some LivesViewModelProtocol {
        let repository = RemainingLivesRepository(
            game: self.gameId,
            storage: self.storage
        )
        return RemainingLivesViewModel(
            gameSettings: self.gameSettings,
            repository: repository
        )
    }
}
