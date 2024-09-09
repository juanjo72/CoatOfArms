//
//  MultipleChoiceViewModelFactory.swift
//  CoatOfArms
//
//  Created on 3/9/24.
//

struct MultipleChoiceViewModelFactory {
    private let game: GameStamp
    private let gameSettings: GameSettings
    private let storage: any StorageProtocol
    private let nextAction: () async -> Void
    
    init(
        game: GameStamp,
        gameSettings: GameSettings,
        storage: any StorageProtocol,
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
            id: .init(game: self.game, countryCode: code),
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
