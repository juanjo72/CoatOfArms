//
//  QuestionViewModelFactory.swift
//  CoatOfArms
//
//  Created on 3/9/24.
//
    
import Combine

struct QuestionViewModelFactory {
    private let gameId: GameStamp
    private let gameSettings: GameSettings
    private let network: any NetworkProtocol
    private let router: any GameRouterProtocol
    private let storage: any StorageProtocol
    
    init(
        gameId: GameStamp,
        gameSettings: GameSettings,
        network: any NetworkProtocol,
        router: any GameRouterProtocol,
        storage: any StorageProtocol
    ) {
        self.gameId = gameId
        self.gameSettings = gameSettings
        self.storage = storage
        self.network = network
        self.router = router
    }

    func make(code: CountryCode) -> some QuestionViewModelProtocol {
        let multipleChoiceViewModelFactory = MultipleChoiceViewModelFactory(
            game: self.gameId,
            gameSettings: self.gameSettings,
            router: self.router,
            storage: self.storage
        )
        let repository = QuestionRepository(
            countryCode: code,
            network: self.network,
            storage: self.storage
        )
        return QuestionViewModel(
            countryCode: code,
            multipleChoiceProvider: {
                multipleChoiceViewModelFactory.make(code: code)
            },
            remoteImagePrefetcher: { url in
                Just(url)
                    .imagePrefech()
                    .eraseToAnyPublisher()
            },
            repository: repository,
            router: self.router
        )
    }
}
