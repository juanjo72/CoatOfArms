//
//  PossibleAnswersRepository.swift
//  CoatOfArms
//
//  Created on 14/8/24.
//

import Combine
import ReactiveStorage

protocol MultipleChoiceRepositoryProtocol {
    var multipleChoiceObservable: AnyPublisher<MultipleChoice?, Never> { get }
    var storedAnswerObservable: AnyPublisher<UserChoice?, Never> { get }
    func fetchAnswers() async
    func set(answer: CountryCode) async
}

/// Multiple choice view's data layer
struct MultipleChoiceRepository: MultipleChoiceRepositoryProtocol {
    
    // MARK: Injected
    
    private let game: GameStamp
    private let countryCode: CountryCode
    private let gameSettings: GameSettings
    private let randomCountryCodeProvider: any RandomCountryCodeProviderProtocol
    private let storage: any ReactiveStorage.ReactiveStorageProtocol
    
    // MARK: MultipleChoiceRepositoryProtocol
    
    var storedAnswerObservable: AnyPublisher<UserChoice?, Never> {
        self.storage.getSingleElementObservable(of: UserChoice.self, id: self.countryCode)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var multipleChoiceObservable: AnyPublisher<MultipleChoice?, Never> {
        self.storage.getSingleElementObservable(of: MultipleChoice.self, id: self.countryCode)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        game: GameStamp,
        countryCode: CountryCode,
        gameSettings: GameSettings,
        randomCountryCodeProvider: any RandomCountryCodeProviderProtocol,
        storage: any ReactiveStorage.ReactiveStorageProtocol
    ) {
        self.game = game
        self.countryCode = countryCode
        self.gameSettings = gameSettings
        self.randomCountryCodeProvider = randomCountryCodeProvider
        self.storage = storage
    }
    
    // MARK: PossibleAnswersRepositoryProtocol
    
    func fetchAnswers() async {
        let otherChoices = self.randomCountryCodeProvider.generateCodes(
            n: self.gameSettings.numPossibleChoices - 1,
            excluding: [self.countryCode]
        )
        let rightChoicePosition = (0..<self.gameSettings.numPossibleChoices).randomElement()!
        let answers = MultipleChoice(
            id: self.countryCode,
            game: self.game,
            otherChoices: otherChoices,
            rightChoicePosition: rightChoicePosition
        )
        await self.storage.add(answers)
    }
    
    func set(answer: CountryCode) async {
        let answer = UserChoice(
            id: self.countryCode,
            game: self.game,
            pickedCountryCode: answer
        )
        await self.storage.add(answer)
    }
}
