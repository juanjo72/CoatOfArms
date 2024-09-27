//
//  RemainingLivesRepository.swift
//  CoatOfArms
//
//  Created on 22/9/24.
//

@testable import CoatOfArms
import Combine
import Foundation
import Testing

@Suite("RemainingLivesRepository", .tags(.dataLayer))
struct RemainingLivesRepositoryTests {
    
    // MARK: SUT
    
    private func makeSUT(
        gameStamp: GameStamp = Date(timeIntervalSince1970: 0),
        store: StorageProtocolMock = .init()
    ) -> RemainingLivesRepository {
        RemainingLivesRepository(
            gameStamp: gameStamp,
            store: store
        )
    }
    
    // MARK: wrongAnswers
    
    @Test("Observing: filters out other games")
    func testThat_WhenWrongAnswersAreObserved_ThenOnlyThisGameOnesAreObserved() async {
        // Given
        let store = StorageProtocolMock()
        store.getAllElementsObservableOfReturnValue = Just(
            [
                UserChoice.make(game: Date(timeIntervalSince1970: 1)),
            ]
        ).eraseToAnyPublisher()
        let sut = self.makeSUT(
            gameStamp: Date(timeIntervalSince1970: 0),
            store: store
        )
        
        // When
        let choices = await sut.wrongAnswers.values.first { _ in true }
        
        // Then
        #expect(choices == [])
    }
    
    @Test("Observing: filters out succesful ones")
    func testThat_WhenWrongAnswersAreObserved_ThenOnlyWrongOnesAreObserved() async {
        // Given
        let store = StorageProtocolMock()
        store.getAllElementsObservableOfReturnValue = Just(
            [
                UserChoice.make(countryCode: "ES", pickedCountryCode: "ES"),
            ]
        ).eraseToAnyPublisher()
        let sut = self.makeSUT(
            store: store
        )
        
        // When
        let choices = await sut.wrongAnswers.values.first { _ in true }
        
        // Then
        #expect(choices == [])
    }
}
