//
//  PossibleAnswersRepository.swift
//  CoatOfArms
//
//  Created on 14/8/24.
//

import Combine

protocol MultipleChoiceRepositoryProtocol {
    var multipleChoiceObservable: AnyPublisher<MultipleChoice?, Never> { get }
    var userChoiceObservable: AnyPublisher<UserChoice?, Never> { get }
    func fetchAnswers() async
    func set(answer: CountryCode) async
}

/// Multiple choice view's data layer
struct MultipleChoiceRepository: MultipleChoiceRepositoryProtocol {
    
    // MARK: Injected
    
    private let id: MultipleChoice.ID
    private let gameSettings: GameSettings
    private let randomCountryCodeProvider: any RandomCountryCodeProviderProtocol
    private let storage: any StorageProtocol
    
    // MARK: MultipleChoiceRepositoryProtocol
    
    var userChoiceObservable: AnyPublisher<UserChoice?, Never> {
        self.storage.getSingleElementObservable(
            of: UserChoice.self,
            id: UserChoice.ID(
                game: self.id.game,
                countryCode: self.id.countryCode
            )
        )
        .eraseToAnyPublisher()
    }
    
    var multipleChoiceObservable: AnyPublisher<MultipleChoice?, Never> {
        self.storage.getSingleElementObservable(
            of: MultipleChoice.self,
            id: self.id
        )
        .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        id: MultipleChoice.ID,
        gameSettings: GameSettings,
        randomCountryCodeProvider: any RandomCountryCodeProviderProtocol,
        storage: StorageProtocol
    ) {
        self.id = id
        self.gameSettings = gameSettings
        self.randomCountryCodeProvider = randomCountryCodeProvider
        self.storage = storage
    }
    
    // MARK: PossibleAnswersRepositoryProtocol
    
    func fetchAnswers() async {
        let otherChoices = self.randomCountryCodeProvider.generateCodes(
            n: self.gameSettings.numPossibleChoices - 1,
            excluding: [self.id.countryCode]
        )
        let rightChoicePosition = (0..<self.gameSettings.numPossibleChoices).randomElement()!
        let answers = MultipleChoice(
            id: self.id,
            otherChoices: otherChoices,
            rightChoicePosition: rightChoicePosition
        )
        await self.storage.add(answers)
    }
    
    func set(answer: CountryCode) async {
        let answer = UserChoice(
            id: UserChoice.ID(
                game: self.id.game,
                countryCode: self.id.countryCode
            ),
            pickedCountryCode: answer
        )
        await self.storage.add(answer)
    }
}
