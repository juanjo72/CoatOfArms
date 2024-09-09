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
    private let storage: any StorageProtocol
    private let nextAction: () async -> Void
    
    init(
        gameId: GameStamp,
        gameSettings: GameSettings,
        network: any NetworkProtocol,
        storage: any StorageProtocol,
        nextAction: @escaping () async -> Void
    ) {
        self.gameId = gameId
        self.gameSettings = gameSettings
        self.storage = storage
        self.network = network
        self.nextAction = nextAction
    }

    func make(code: CountryCode) -> some QuestionViewModelProtocol {
        let multipleChoiceViewModelFactory = MultipleChoiceViewModelFactory(
            game: self.gameId,
            gameSettings: self.gameSettings,
            storage: self.storage,
            nextAction: self.nextAction
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
                    .prefetch()
                    .eraseToAnyPublisher()
            },
            repository: repository,
            nextAction: self.nextAction
        )
    }
}
