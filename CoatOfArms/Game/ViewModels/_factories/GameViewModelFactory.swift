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
    private let store: any StorageProtocol
    
    init(
        gameSettings: GameSettings,
        network: any NetworkProtocol,
        store: any StorageProtocol
    ) {
        self.gameSettings = gameSettings
        self.network = network
        self.store = store
    }
    
    func make(stamp: GameStamp) -> some GameViewModelProtocol {
        let randomCountryProvider = RandomCountryCodeProvider()
        let remainingLives = RemainingLivesViewModelFactory(
            gameStamp: stamp,
            gameSettings: self.gameSettings,
            store: self.store
        ).make()
        var questionFactory: QuestionViewModelFactory!
        let router = GameRouter(
            gameStamp: stamp,
            gameSettings: gameSettings,
            questionProvider: {
                questionFactory.make(code: $0)
            },
            randomCodeProvider: randomCountryProvider,
            remainingLives: remainingLives,
            store: store
        )
        questionFactory = QuestionViewModelFactory(
            gameStamp: stamp,
            gameSettings: self.gameSettings,
            network: self.network,
            randomCountryCodeProvider: randomCountryProvider,
            router: router,
            store: self.store
        )
        let gameViewModel = GameViewModel(
            gameStamp: stamp,
            router: router
        )
        return gameViewModel
    }
}
