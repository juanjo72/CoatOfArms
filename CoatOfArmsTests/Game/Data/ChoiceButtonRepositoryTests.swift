//
//  ChoiceButtonRepositoryTests.swift
//  CoatOfArms
//
//  Created on 22/9/24.
//

@testable import CoatOfArms
import Combine
import Foundation
import Testing

@Suite("ChoiceButtonRepository", .tags(.dataLayer))
struct ChoiceButtonRepositoryTests {
    
    // MARK: SUT

    private func makeSUT(
        buttonCode: CountryCode = "IT",
        questionId: Question.ID = .make(countryCode: "ES"),
        store: StorageProtocolMock = .init()
    ) -> ChoiceButtonRepository {
        ChoiceButtonRepository(
            buttonCode: buttonCode,
            questionId: questionId,
            store: store
        )
    }
    
    // MARK: markAsChoice
    
    @Test("markAsChoice")
    func testThat_WhenMarkAsChoice_ThenChoiceIsStoredAndReturned() async throws {
        // MARK: Given
        let store = StorageProtocolMock()
        let sut = self.makeSUT(
            store: store
        )
        
        // MARK: When
        let choice = await sut.markAsChoice()
        
        // Then
        #expect(store.addCallsCount == 1)
        #expect(store.addReceivedElement as? UserChoice == UserChoice.make(countryCode: "ES", pickedCountryCode: "IT"))
        #expect(choice == store.addReceivedElement as? UserChoice)
        #expect(choice.isCorrect == false)
    }
    
    // MARK: userChoiceObservable
    
    @Test("Observing answered question")
    func testThat_WhenSubscribedToUserChoice_And_Answered_ThenReturnsUserChoice() async throws {
        // MARK: Given
        let storedChoice = UserChoice.make()
        let store = StorageProtocolMock()
        store.getSingleElementObservableOfIdReturnValue = Just<UserChoice?>(storedChoice).eraseToAnyPublisher()
        let questionId: Question.ID = .make()
        let sut = self.makeSUT(
            questionId: questionId,
            store: store
        )
        
        // MARK: When
        let observedChoice = await sut.userChoiceObservable.values.first { _ in true } as? UserChoice
        
        // Then
        #expect(store.getSingleElementObservableOfIdReceivedArguments?.id as? Question.ID == questionId)
        #expect(observedChoice == storedChoice)
    }
    
    @Test("Observing not answered question")
    func testThat_WhenSubscribedToUserChoice_And_NotAnswered_ThenReturnsNil() async throws {
        // MARK: Given
        let store = StorageProtocolMock()
        store.getSingleElementObservableOfIdReturnValue = Just<UserChoice?>(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            store: store
        )

        // MARK: When
        let observedChoice = await sut.userChoiceObservable.values.first { _ in true } as? UserChoice
        
        // Then
        #expect(observedChoice == nil)
    }
}
