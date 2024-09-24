//
//  RemainingLivesViewModelTests.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

@testable import CoatOfArms
import Combine
import Testing

@Suite("RemainigLivesViewModel", .tags(.logicLayer))
struct ReminingLivesViewModelTests {
    
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
    
    @Test("Total lives")
    private func testThat_WhenCreated_ThenTotalLivesAreEqualToSettings() async throws {
        // Given
        let gameSettings = GameSettings.make(maxWrongAnwers: 3)
        let repository = RemainingLivesRepositoryProtocolMock()
        repository.wrongAnswers = Just([]).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            gameSettings: gameSettings,
            repository: repository
        )
        
        // Then
        #expect(sut.totalLives == 3)
    }
    
    @Test("Current lives")
    private func testThat_WhenCreated_Then() async throws {
        // Given
        let gameSettings = GameSettings.make(maxWrongAnwers: 3)
        let repository = RemainingLivesRepositoryProtocolMock()
        repository.wrongAnswers = Just(
            [
                UserChoice.make(countryCode: "ES", pickedCountryCode: "FR"),
                UserChoice.make(countryCode: "IT", pickedCountryCode: "FR"),
            ]
        ).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            gameSettings: gameSettings,
            repository: repository
        )
        
        // Then
        #expect(sut.numberOfLives == 1)
    }
}
