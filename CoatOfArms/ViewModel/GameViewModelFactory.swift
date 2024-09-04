//
// GameViewModelFactory.swift
// CoatOfArms
//
// Created on 3/9/24

import Combine
import Foundation
import Network
import ReactiveStorage

struct GameViewModelFactory {
    private let gameSettings: GameSettings
    private let requestSender: RequestSenderProtocol
    private let storage: ReactiveStorageProtocol
    
    init(
        gameSettings: GameSettings,
        requestSender: RequestSenderProtocol,
        storage: ReactiveStorageProtocol
    ) {
        self.gameSettings = gameSettings
        self.requestSender = requestSender
        self.storage = storage
    }
    
    func make(stamp: GameStamp) -> some GameViewModelProtocol {
        let randomCountryProvider = RandomCountryCodeProvider()
        let remainingLives = LivesViewModelFactory(
            gameId: stamp,
            gameSettings: self.gameSettings,
            storage: self.storage
        ).make()
        var questionFactory: QuestionViewModelFactory!
        let router = GameViewModel(
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
            storage: self.storage,
            requestSender: self.requestSender,
            next: router.next
        )
        return router
    }
}
