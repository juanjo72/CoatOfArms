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
    
    // MARK: Injected
    
    private let buttonCode: CountryCode
    private let questionId: Question.ID
    private let store: any StorageProtocol
    
    // MARK: ChoiceButtonRepositoryProtocol
    
    var userChoiceObservable: AnyPublisher<UserChoice?, Never> {
        self.store.getSingleElementObservable(
            of: UserChoice.self,
            id: self.questionId
        )
        .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        buttonCode: CountryCode,
        questionId: Question.ID,
        store: any StorageProtocol
    ) {
        self.buttonCode = buttonCode
        self.questionId = questionId
        self.store = store
    }
    
    // MARK: ChoiceButtonRepositoryProtocol
    
    func markAsChoice() async -> UserChoice {
        let answer = UserChoice(
            id: self.questionId,
            pickedCountryCode: self.buttonCode
        )
        await self.store.add(answer)
        return answer
    }
}
