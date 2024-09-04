//
// QuestionViewModelFactory.swift
// CoatOfArms
//
// Created on 3/9/24
    
import Combine
import ReactiveStorage
import Network

struct QuestionViewModelFactory {
    private let gameId: GameStamp
    private let gameSettings: GameSettings
    private let storage: ReactiveStorageProtocol
    private let requestSender: RequestSenderProtocol
    private let nextAction: () async -> Void
    
    init(
        gameId: GameStamp,
        gameSettings: GameSettings,
        storage: ReactiveStorageProtocol,
        requestSender: RequestSenderProtocol,
        nextAction: @escaping () async -> Void
    ) {
        self.gameId = gameId
        self.gameSettings = gameSettings
        self.storage = storage
        self.requestSender = requestSender
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
            requestSender: self.requestSender,
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
