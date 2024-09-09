//
// RemainingLivesViewModelTests.swift
// CoatOfArmsTests
//
// Created on 8/9/24
//
    
@testable import CoatOfArms
import Combine
import XCTest

final class RemainingLivesViewModelTests: XCTestCase {
    
    // MARK: SUT
    
    private func makeSUT(
        gameSettings: GameSettings = .default,
        repository: RemainingLivesRepositoryProtocolMock = .init()
    ) -> some RemainingLivesViewModelProtocol {
        RemainingLivesViewModel(
            gameSettings: gameSettings,
            outputScheduler: ImmediateScheduler.shared,
            repository: repository
        )
    }
    
    // MARK: totalLives
    
    func testThat_WhenCreated_ThenTotalLivesIsMaxWrongAnwers() {
        // Given
        let gameSettings = GameSettings.makeDouble(maxWrongAnwers: 3)
        let repository = RemainingLivesRepositoryProtocolMock()
        repository.wrongAnswers = Just([]).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            gameSettings: gameSettings,
            repository: repository
        )
        
        // Then
        XCTAssertEqual(sut.totalLives, 3)
    }
    
    // MARK: numOfLives
    
    func testThat_GivenWrongAnswerCount_WhenCreated_ThenRemaininLivesAreCorrect() {
        // Given
        let gameSettings = GameSettings.makeDouble(maxWrongAnwers: 3)
        let repository = RemainingLivesRepositoryProtocolMock()
        repository.wrongAnswers = Just(
            [
                UserChoice.makeDouble(countryCode: "ES", pickedCountryCode: "IT"),
            ]
        ).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            gameSettings: gameSettings,
            repository: repository
        )
        
        XCTAssertEqual(sut.numberOfLives, 2)
    }
}
