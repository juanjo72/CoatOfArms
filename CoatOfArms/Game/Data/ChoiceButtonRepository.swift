//
//  ChoiceButtonRepository.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

import Combine

protocol ChoiceButtonRepositoryProtocol {
    var userChoiceObservable: AnyPublisher<UserChoice?, Never> { get }
    func markAsChoice() async -> UserChoice
}

struct ChoiceButtonRepository: ChoiceButtonRepositoryProtocol {
    typealias QuestionId = (gameStamp: GameStamp, countryCode: CountryCode)
    
    // MARK: Injected
    
    private let id: CountryCode
    private let questionId: QuestionId
    private let storage: any StorageProtocol
    
    // MARK: ChoiceButtonRepositoryProtocol
    
    var userChoiceObservable: AnyPublisher<UserChoice?, Never> {
        self.storage.getSingleElementObservable(
            of: UserChoice.self,
            id: UserChoice.ID(
                game: self.questionId.gameStamp,
                countryCode: self.questionId.countryCode
            )
        )
        .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        id: CountryCode,
        questionId: QuestionId,
        storage: any StorageProtocol
    ) {
        self.id = id
        self.questionId = questionId
        self.storage = storage
    }
    
    // MARK: ChoiceButtonRepositoryProtocol
    
    func markAsChoice() async -> UserChoice {
        let answer = UserChoice(
            id: UserChoice.ID(
                game: self.questionId.gameStamp,
                countryCode: self.questionId.countryCode
            ),
            pickedCountryCode: self.id
        )
        await self.storage.add(answer)
        return answer
    }
}
