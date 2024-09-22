//
//  RemainingLivesViewModelFactory.swift
//  CoatOfArms
//
//  Created on 3/9/24.
//

struct RemainingLivesViewModelFactory {
    private let gameStamp: GameStamp
    private let gameSettings: GameSettings
    private let store: any StorageProtocol
    
    init(
        gameStamp: GameStamp,
        gameSettings: GameSettings,
        store: any StorageProtocol
    ) {
        self.gameStamp = gameStamp
        self.gameSettings = gameSettings
        self.store = store
    }
    
    func make() -> some RemainingLivesViewModelProtocol {
        let repository = RemainingLivesRepository(
            gameStamp: self.gameStamp,
            store: self.store
        )
        return RemainingLivesViewModel(
            gameSettings: self.gameSettings,
            repository: repository
        )
    }
}
