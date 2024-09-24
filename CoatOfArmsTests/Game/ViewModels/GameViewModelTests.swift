//
//  GameViewModelTests.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

@testable import CoatOfArms
import Combine
import Foundation
import Testing

@Suite("ChoiceButtonVewModel", .tags(.logicLayer))
struct GameViewModelTests {
    typealias RouterPath = GameStatus<QuestionViewModelProtocolMock, RemainingLivesViewModelProtocolMock>
    
    // MARK: SUT
    
    private func makeSUT(
        gameStamp: GameStamp = Date(timeIntervalSince1970: 0),
        router: GameRouterProtocolMock = .init()
    ) -> some GameViewModelProtocol {
        GameViewModel(
            gameStamp: gameStamp,
            outputScheduler: ImmediateScheduler.shared,
            router: router
        )
    }
    
    // MARK: viewWillAppear
    
    @Test("Game start")
    func testThat_WhenViewWillAppear_ThenRouterIsCalled() async throws {
        // Given
        let router = GameRouterProtocolMock()
        router.pathObservable = Just(.idle).eraseToAnyPublisher()
        let sut = self.makeSUT(
            router: router
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        #expect(router.gotNextQuestionCallsCount == 1)
    }
    
    @Test("State when idle")
    func testThat_WhenCreated_And_Idle_ThenStateMatchesRouterPath() async throws {
        // Given
        let router = GameRouterProtocolMock()
        router.pathObservable = Just(.idle).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            router: router
        )
        
        // Then
        #expect(sut.status.isIdle)
    }
    
    @Test("State when Playing")
    func testThat_WhenCreated_And_Playing_ThenStateMatchesRouterPath() async throws {
        // Given
        let router = GameRouterProtocolMock()
        let question = QuestionViewModelProtocolMock()
        question.countryCode = "ES"
        let remainingLives = RemainingLivesViewModelProtocolMock()
        remainingLives.numberOfLives = 1
        remainingLives.totalLives = 3
        let path = RouterPath.playing(question: question, remainingLives: remainingLives)
        router.pathObservable = Just(path).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            router: router
        )
        
        // Then
        #expect(sut.status.playing?.question.countryCode == "ES")
        #expect(sut.status.playing?.lives.numberOfLives == 1)
        #expect(sut.status.playing?.lives.totalLives == 3)
    }
    
    @Test("State when GameOver")
    func testThat_WhenCreated_And_GameOver_ThenStateMatchesRouterPath() async throws {
        // Given
        let router = GameRouterProtocolMock()
        router.pathObservable = Just(.gameOver(score: 8)).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            router: router
        )
        
        // Then
        #expect(sut.status.gameOverScore == 8)
    }
}
