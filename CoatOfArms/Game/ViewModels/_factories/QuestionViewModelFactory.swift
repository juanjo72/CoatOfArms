//
//  QuestionViewModelFactory.swift
//  CoatOfArms
//
//  Created on 3/9/24.
//
    
import Combine

struct QuestionViewModelFactory {
    private let gameStamp: GameStamp
    private let gameSettings: GameSettings
    private let network: any NetworkProtocol
    private let randomCountryCodeProvider: any RandomCountryCodeProviderProtocol
    private let router: any GameRouterProtocol
    private let store: any StorageProtocol
    
    init(
        gameStamp: GameStamp,
        gameSettings: GameSettings,
        network: any NetworkProtocol,
        randomCountryCodeProvider: any RandomCountryCodeProviderProtocol,
        router: any GameRouterProtocol,
        store: any StorageProtocol
    ) {
        self.gameStamp = gameStamp
        self.gameSettings = gameSettings
        self.store = store
        self.network = network
        self.randomCountryCodeProvider = randomCountryCodeProvider
        self.router = router
    }

    func make(code: CountryCode) -> some QuestionViewModelProtocol {
        let questionId = Question.ID(
            gameStamp: self.gameStamp,
            countryCode: code
        )
        let repository = QuestionRepository(
            questionId: questionId,
            gameSettings: self.gameSettings,
            network: self.network,
            randomCountryCodeProvider: self.randomCountryCodeProvider,
            storage: self.store
        )
        let buttonFactory = ChoiceButtonViewModelFactory(
            questionId: questionId,
            gameSettings: self.gameSettings,
            router: self.router,
            store: self.store
        )
        return QuestionViewModel(
            countryCode: code,
            buttonProvider: buttonFactory.make,
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
