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
    private let next: () async -> Void
    
    init(
        gameId: GameStamp,
        gameSettings: GameSettings,
        storage: ReactiveStorageProtocol,
        requestSender: RequestSenderProtocol,
        next: @escaping () async -> Void
    ) {
        self.gameId = gameId
        self.gameSettings = gameSettings
        self.storage = storage
        self.requestSender = requestSender
        self.next = next
    }

    func make(code: CountryCode) -> some QuestionViewModelProtocol {
        let multipleChoiceViewModelFactory = MultipleChoiceViewModelFactory(
            game: self.gameId,
            gameSettings: self.gameSettings,
            storage: self.storage,
            next: self.next
        )
        let repository = QuestionRepository(
            countryCode: code,
            requestSender: self.requestSender,
            storage: self.storage
        )
        return QuestionViewModel(
            multipleChoiceProvider: {
                multipleChoiceViewModelFactory.make(code: code)
            },
            remoteImagePrefetcher: { url in
                Just(url)
                    .prefetch()
                    .eraseToAnyPublisher()
            },
            repository: repository,
            next: self.next
        )
    }
}
