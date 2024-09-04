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
    private let next: () async -> Void
    
    init(
        game: GameStamp,
        gameSettings: GameSettings,
        storage: ReactiveStorageProtocol,
        next: @escaping () async -> Void
    ) {
        self.game = game
        self.gameSettings = gameSettings
        self.storage = storage
        self.next = next
    }
    
    func make(code: CountryCode) -> some MultipleChoiceViewModelProtocol {
        let randomCountryCodeProvider = RandomCountryCodeProvider()
        let repository = MultipleChoiceRepository(
            gameId: self.game,
            countryCode: code,
            randomCountryCodeProvider: randomCountryCodeProvider,
            gameSettings: self.gameSettings,
            storage: self.storage
        )
        return MultipleChoiceViewModel(
            gameSettings: self.gameSettings,
            repository: repository,
            next: self.next
        )
    }
}
