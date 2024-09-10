//
//  GameViewModelFactory.swift
//  CoatOfArms
//
//  Created on 3/9/24.
//

import Combine
import Foundation

struct GameViewModelFactory {
    private let gameSettings: GameSettings
    private let network: any NetworkProtocol
    private let storage: any StorageProtocol
    
    init(
        gameSettings: GameSettings,
        network: any NetworkProtocol,
        storage: any StorageProtocol
    ) {
        self.gameSettings = gameSettings
        self.network = network
        self.storage = storage
    }
    
    func make(stamp: GameStamp) -> some GameViewModelProtocol {
        let randomCountryProvider = RandomCountryCodeProvider()
        let remainingLives = RemainingLivesViewModelFactory(
            gameId: stamp,
            gameSettings: self.gameSettings,
            storage: self.storage
        ).make()
        var questionFactory: QuestionViewModelFactory!
        let game = GameViewModel(
            game: stamp,
            gameSettings: self.gameSettings,
            questionProvider: {
                questionFactory.make(code: $0)
            },
            randomCountryCodeProvider: randomCountryProvider,
            remainingLives: remainingLives,
            storage: self.storage
        )
        questionFactory = QuestionViewModelFactory(
            gameId: stamp,
            gameSettings: self.gameSettings,
            network: self.network,
            storage: self.storage,
            nextAction: { [weak game] in
                await game?.next()
            }
        )
        return game
    }
}
