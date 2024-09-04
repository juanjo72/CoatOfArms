//
//  PossibleAnswersRepository.swift
//  CoatOfArms
//
//  Created on 14/8/24.
//

import Combine
import ReactiveStorage

protocol MultipleChoiceRepositoryProtocol {
    func multipleChoiceObservable() -> AnyPublisher<MultipleChoice?, Never>
    func storedAnswerObservable() -> AnyPublisher<UserChoice?, Never>
    func fetchAnswers() async
    func set(answer: CountryCode) async
}

struct MultipleChoiceRepository: MultipleChoiceRepositoryProtocol {
    
    // MARK: Injected
    
    private let gameId: GameStamp
    private let countryCode: CountryCode
    private let randomCountryCodeProvider: RandomCountryCodeProviderProtocol
    private let gameSettings: GameSettings
    private let storage: ReactiveStorage.ReactiveStorageProtocol
    
    // MARK: Lifecycle
    
    init(
        gameId: GameStamp,
        countryCode: CountryCode,
        randomCountryCodeProvider: RandomCountryCodeProviderProtocol,
        gameSettings: GameSettings,
        storage: ReactiveStorage.ReactiveStorageProtocol
    ) {
        self.gameId = gameId
        self.countryCode = countryCode
        self.randomCountryCodeProvider = randomCountryCodeProvider
        self.gameSettings = gameSettings
        self.storage = storage
    }
    
    // MARK: PossibleAnswersRepositoryProtocol
    
    func storedAnswerObservable() -> AnyPublisher<UserChoice?, Never> {
        self.storage.getSingleElementObservable(of: UserChoice.self, id: self.countryCode)
            .eraseToAnyPublisher()
    }
    
    func multipleChoiceObservable() -> AnyPublisher<MultipleChoice?, Never> {
        self.storage.getSingleElementObservable(of: MultipleChoice.self, id: self.countryCode)
            .eraseToAnyPublisher()
    }
    
    func fetchAnswers() async {
        let otherChoices = self.randomCountryCodeProvider.generateCodes(
            n: self.gameSettings.numPossibleChoices - 1,
            excluding: [self.countryCode]
        )
        let rightChoicePosition = (0..<self.gameSettings.numPossibleChoices).randomElement()!
        let answers = MultipleChoice(
            id: self.countryCode,
            gameId: self.gameId,
            otherChoices: otherChoices,
            rightChoicePosition: rightChoicePosition
        )
        await self.storage.add(answers)
    }
    
    func set(answer: CountryCode) async {
        let answer = UserChoice(
            id: self.countryCode,
            gameId: self.gameId,
            pickedCountryCode: answer
        )
        await self.storage.add(answer)
    }
}
