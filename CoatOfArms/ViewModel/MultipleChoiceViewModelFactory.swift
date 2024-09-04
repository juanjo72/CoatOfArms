//
// MultipleChoiceViewModelFactory.swift
// CoatOfArms
//
// Created on 3/9/24
    

import ReactiveStorage

struct MultipleChoiceViewModelFactory {
    private let game: GameStamp
    private let gameSettings: GameSettings
    private let storage: ReactiveStorageProtocol
    private let nextAction: () async -> Void
    
    init(
        game: GameStamp,
        gameSettings: GameSettings,
        storage: ReactiveStorageProtocol,
        nextAction: @escaping () async -> Void
    ) {
        self.game = game
        self.gameSettings = gameSettings
        self.storage = storage
        self.nextAction = nextAction
    }
    
    func make(code: CountryCode) -> some MultipleChoiceViewModelProtocol {
        let randomCountryCodeProvider = RandomCountryCodeProvider()
        let repository = MultipleChoiceRepository(
            game: self.game,
            countryCode: code,
            gameSettings: self.gameSettings,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: self.storage
        )
        return MultipleChoiceViewModel(
            gameSettings: self.gameSettings,
            repository: repository,
            nextAction: self.nextAction
        )
    }
}
