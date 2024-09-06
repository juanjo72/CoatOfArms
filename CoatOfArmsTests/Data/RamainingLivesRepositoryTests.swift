//
// RamainingLivesRepositoryTests.swift
// CoatOfArmsTests
//
// Created on 6/9/24

@testable import CoatOfArms
import Combine
import ReactiveStorage
import XCTest

final class RamainingLivesRepositoryTests: XCTestCase {

    // MARK: SUT
    
    private func makeSUT(
        game: GameStamp = Date(timeIntervalSince1970: 0),
        storage: ReactiveStorageProtocol = ReactiveStorageProtocolMock<UserChoice>()
    ) -> RemainingLivesRepository {
        RemainingLivesRepository(
            game: game,
            storage: storage
        )
    }
    
    // MARK: wrongAnswers
    
    func testThat_WhenWrongAnswersAreObserved_ThenOnlyThisGameOnesAreObserved() {
        // Given
        let storage = ReactiveStorageProtocolMock<UserChoice>()
        storage.getAllElementsObservableOfReturnValue = Just(
            [
                UserChoice.makeDouble(game: Date(timeIntervalSince1970: 1)),
            ]
        ).eraseToAnyPublisher()
        let sut = self.makeSUT(
            game: Date(timeIntervalSince1970: 0),
            storage: storage
        )
        
        // When
        var choices: [UserChoice] = []
        _ = sut.wrongAnswers.sink { choices = $0 }
        
        // Then
        XCTAssertEqual(choices, [])
    }
    
    func testThat_WhenWrongAnswersAreObserved_ThenOnlyWrongOnesAreObserved() {
        // Given
        let storage = ReactiveStorageProtocolMock<UserChoice>()
        storage.getAllElementsObservableOfReturnValue = Just(
            [
                UserChoice.makeDouble(countryCode: "ES", pickedCountryCode: "ES"),
            ]
        ).eraseToAnyPublisher()
        let sut = self.makeSUT(
            storage: storage
        )
        
        // When
        var choices: [UserChoice] = []
        _ = sut.wrongAnswers.sink { choices = $0 }
        
        // Then
        XCTAssertEqual(choices, [])
    }
}
