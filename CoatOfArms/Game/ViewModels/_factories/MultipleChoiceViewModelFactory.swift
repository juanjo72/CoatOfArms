//
//  MultipleChoiceViewModelFactory.swift
//  CoatOfArms
//
//  Created on 3/9/24.
//

struct MultipleChoiceViewModelFactory {
    private let game: GameStamp
    private let gameSettings: GameSettings
    private let router: any GameRouterProtocol
    private let storage: any StorageProtocol
    
    init(
        game: GameStamp,
        gameSettings: GameSettings,
        router: any GameRouterProtocol,
        storage: any StorageProtocol
    ) {
        self.game = game
        self.gameSettings = gameSettings
        self.storage = storage
        self.router = router
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
            playSound: PlaySound(),
            repository: repository,
            router: self.router
        )
    }
}
