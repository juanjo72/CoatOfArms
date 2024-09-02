//
//  GameRouterTests.swift
//  CoatOfArmsTests
//
//  Created on 2/9/24.
//

import Combine
@testable import CoatOfArms
import ReactiveStorage
import XCTest

final class GameRouterTests: XCTestCase {
    
    // MARK: SUT
    
    private func makeSUT(
        gameSettings: GameSettings = .default,
        randomCountryCodeProvider: RandomCountryCodeProviderProtocolMock = .init(),
        storage: ReactiveStorageProtocolMock<UserChoice> = ReactiveStorageProtocolMock<UserChoice>()
    ) -> GameRouter<ImmediateScheduler> {
        GameRouter(
            gameSettings: gameSettings,
            outputScheduler: ImmediateScheduler.shared,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: storage
        )
    }
    
    // MARK: Initial state
    
    func testThat_WhenCreated_ThenScreenIsCreatedWithFirstCode() {
        // Given
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        let startCode = "ES"
        randomCountryCodeProvider.generateCodeExcludingReturnValue = startCode
        
        // When
        let sut = self.makeSUT(
            randomCountryCodeProvider: randomCountryCodeProvider
        )
        
        // Then
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingCallsCount, 1)
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingReceivedExcluding, [])
        XCTAssertEqual(sut.screen, .question(code: startCode))
    }
    
    // MARK: next
    
    func testThat_WhenNext_And_WrongAnswersAreEqualOrGraterToSettings_ThenGameOverScreenIsDisplayed() async {
        // Given
        let gameSettings = GameSettings(numPossibleChoices: 3, resultTime: .seconds(1), maxWrongAnswers: 2)
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        randomCountryCodeProvider.generateCodesNExcludingReturnValue = ["AR"]
        let storage = ReactiveStorageProtocolMock<UserChoice>()
        storage.getAllElementsOfReturnValue = [
            UserChoice(id: "US", pickedCountryCode: "US"), // right answer
            UserChoice(id: "AR", pickedCountryCode: "ES"), // wrong
            UserChoice(id: "ES", pickedCountryCode: "US"), // wrong
        ]
        let sut = self.makeSUT(
            gameSettings: gameSettings,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: storage
        )
        
        // When
        await sut.next()
        
        // Then
        XCTAssertEqual(sut.screen, .gameOver(score: 1))
    }
    
    func testThat_WhenNext_And_WrongAnswersAreLessThanSettings_ThenScreenIsDisplayedWithNewCode() async {
        // Given
        let gameSettings = GameSettings(numPossibleChoices: 3, resultTime: .seconds(1), maxWrongAnswers: 2)
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        randomCountryCodeProvider.generateCodesNExcludingReturnValue = ["AR"]
        let storage = ReactiveStorageProtocolMock<UserChoice>()
        storage.getAllElementsOfReturnValue = [
            UserChoice(id: "US", pickedCountryCode: "US"), // right answer
            UserChoice(id: "AR", pickedCountryCode: "ES"), // wrong
        ]
        let sut = self.makeSUT(
            gameSettings: gameSettings,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: storage
        )
        
        // When
        await sut.next()
        
        // Then
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingReceivedExcluding, ["US", "AR"])
        XCTAssertEqual(sut.screen, .question(code: "ES"))
    }
    
    // MARK: reset
    
    func testThat_WhenReset_ThenRemoveAllAnswersIsCalled() async {
        // Given
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        let storage = ReactiveStorageProtocolMock<UserChoice>()
        storage.getAllElementsOfReturnValue = []
        let sut = self.makeSUT(
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: storage
        )
        
        // When
        await sut.reset()
        
        // Then
        XCTAssertEqual(storage.removeAllElementsOfCallsCount, 1)
        XCTAssertEqual(sut.screen, .question(code: "ES"))
    }
}
