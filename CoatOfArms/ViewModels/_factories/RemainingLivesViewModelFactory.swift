//
//  RemainingLivesViewModelFactory.swift
//  CoatOfArms
//
//  Created on 3/9/24.
//

struct RemainingLivesViewModelFactory {
    private let gameId: GameStamp
    private let gameSettings: GameSettings
    private let storage: any StorageProtocol
    
    init(
        gameId: GameStamp,
        gameSettings: GameSettings,
        storage: any StorageProtocol
    ) {
        self.gameId = gameId
        self.gameSettings = gameSettings
        self.storage = storage
    }
    
    func make() -> some RemainingLivesViewModelProtocol {
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
