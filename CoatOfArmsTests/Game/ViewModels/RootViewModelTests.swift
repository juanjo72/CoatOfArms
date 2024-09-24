//
//  RootViewModelTests.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

@testable import CoatOfArms
import Combine
import Testing

@Suite("RootViewModel", .tags(.logicLayer))
struct RootViewModelTests {
    
    // MARK: SUT
    
    private func makeSUT(
        gameProvider: @escaping (GameStamp) -> GameViewModelProtocolMock = { _ in GameViewModelProtocolMock() }
    ) -> some RootViewModelProtocol {
        RootViewModel(
            gameProvider: gameProvider,
            outputScheduler: ImmediateScheduler.shared
        )
    }
    
    // MARK:
    
    @Test("New Game at start")
    func testThat_WhenViewWillAppear_ThenANewGameIsCreated() async {
        // Given
        var stamp: GameStamp?
        let gameProvider: (GameStamp) -> GameViewModelProtocolMock = {
            stamp = $0
            return GameViewModelProtocolMock()
        }
        let sut = self.makeSUT(
            gameProvider: gameProvider
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        #expect(stamp != nil)
    }
    
    @Test("New Game at restart")
    func testThat_WhenuserDidTapRestart_ThenANewGameIsCreated() async {
        // Given
        var stamp: GameStamp?
        let gameProvider: (GameStamp) -> GameViewModelProtocolMock = {
            stamp = $0
            return GameViewModelProtocolMock()
        }
        let sut = self.makeSUT(
            gameProvider: gameProvider
        )
        
        // When
        await sut.userDidTapRestart()
        
        // Then
        #expect(stamp != nil)
    }
}
