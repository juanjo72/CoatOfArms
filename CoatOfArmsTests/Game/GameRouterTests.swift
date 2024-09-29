//
//  GameRouterTests.swift
//  CoatOfArms
//
//  Created on 29/9/24.
//

@testable import CoatOfArms
import Combine
import Foundation
import Testing

@Suite("Game Router", .tags(.logicLayer))
struct GameRouterTests {
    enum Flow: CaseIterable {
        case start
        case nextQuestion
    }
    
    // MARK: SUT
    
    private func makeSUT(
        gameStamp: GameStamp = Date(timeIntervalSince1970: 0),
        gameSettings: GameSettings = .default,
        questionProvider: @escaping (CountryCode) -> QuestionViewModelProtocolMock = { _ in .init() },
        randomCodeProvider: RandomCountryCodeProviderProtocolMock = .init(),
        remainingLives: RemainingLivesViewModelProtocolMock = .init(),
        store: StorageProtocolMock = .init()
    ) -> some GameRouterProtocol {
        GameRouter(
            gameStamp: gameStamp,
            gameSettings: gameSettings,
            questionProvider: questionProvider,
            randomCodeProvider: randomCodeProvider,
            remainingLives: remainingLives,
            store: store
        )
    }
    
    // MARK: start & goNextQuestion
    
    @Test("Game Go Next Question", arguments: Flow.allCases)
    func testThat_WhenStartOrGoNextQuestionDirectly_ThenGoesToNextQuestion(
        flow: Flow
    ) async throws {
        // Given
        let gameStamp = Date(timeIntervalSince1970: 1)
        let gameSettings: GameSettings = .make(maxWrongAnwers: 2)
        let randomCodeProvider: RandomCountryCodeProviderProtocolMock = .init()
        randomCodeProvider.generateCodeExcludingReturnValue = "ES"
        var code: CountryCode?
        let questionProvider: (CountryCode) -> QuestionViewModelProtocolMock = {
            code = $0
            return .init()
        }
        let store = StorageProtocolMock()
        store.getAllElementsOfReturnValue = [
            UserChoice.make(
                game: GameStamp(timeIntervalSince1970: 0),
                countryCode: "ES",
                pickedCountryCode: "IT"
            ),
            UserChoice.make(
                game: GameStamp(timeIntervalSince1970: 1),
                countryCode: "IT",
                pickedCountryCode: "ES"
            ),
        ]
        let sut = self.makeSUT(
            gameStamp: gameStamp,
            gameSettings: gameSettings,
            questionProvider: questionProvider,
            randomCodeProvider: randomCodeProvider,
            store: store
        )
        
        // When
        switch flow {
        case .start:
            await sut.start()
        case .nextQuestion:
            await sut.gotNextQuestion()
        }
        
        // Then
        #expect(code == "ES")
        #expect(randomCodeProvider.generateCodeExcludingReceivedExcluding == ["ES", "IT"])
        let path = await sut.pathObservable.values.first { _ in true }
        #expect(path?.playing != nil)
    }
    
    @Test("Stop Game")
    func testThat_WhenStopped_ThenPathReturnsToIdle() async throws {
        // Given
        let sut = self.makeSUT()
        
        // When
        await sut.stop()
        
        // Then
        let path = await sut.pathObservable.values.first { _ in true }
        #expect(path?.isIdle == true)
    }
    
    @Test("Game Over")
    func testThat_WhenGoNextQuestion_And_GameOver_ThePathIsGameOverWithTheRightScore() async throws {
        // Given
        let gameStamp = Date(timeIntervalSince1970: 1)
        let gameSettings: GameSettings = .make(maxWrongAnwers: 1)
        let store = StorageProtocolMock()
        store.getAllElementsOfReturnValue = [
            UserChoice.make(
                game: GameStamp(timeIntervalSince1970: 1),
                countryCode: "ES",
                pickedCountryCode: "ES"
            ),
            UserChoice.make(
                game: GameStamp(timeIntervalSince1970: 1),
                countryCode: "IT",
                pickedCountryCode: "FR"
            ),
        ]
        let sut = self.makeSUT(
            gameStamp: gameStamp,
            gameSettings: gameSettings,
            store: store
        )
        
        // When
        await sut.gotNextQuestion()
        
        // Then
        let path = await sut.pathObservable.values.first { _ in true }
        #expect(path?.gameOverScore == 1)
    }
    
    @Test("Error display")
    func testThat_WhenShowError_ThenPathErrorIsObserved() async throws {
        // Given
        let sut = self.makeSUT()
        
        // When
        sut.show(message: "Hello, World!", action: {})
        
        // Then
        let path = await sut.pathObservable.values.first { _ in true }
        #expect(path?.error?.message == "Hello, World!")
    }
}
