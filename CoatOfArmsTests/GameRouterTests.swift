//
//  GameViewModelTests.swift
//  CoatOfArmsTests
//
//  Created on 8/9/24.
//
    
@testable import CoatOfArms
import Combine
import XCTest

final class GameRouterTests: XCTestCase {

    // MARK: SUT
    
    private func makeSUT(
        game: GameStamp = Date(timeIntervalSince1970: 0),
        gameSettings: GameSettings = .default,
        questionProvider: @escaping (CountryCode) -> some QuestionViewModelProtocol = { _ in QuestionViewModelProtocolMock<MultipleChoiceViewModelProtocolMock>() },
        randomCountryCodeProvider: RandomCountryCodeProviderProtocolMock = .init(),
        remainingLives: RemainingLivesViewModelProtocolMock = .init(),
        storage: StorageProtocolMock<UserChoice> = .init()
    ) -> some GameRouterProtocol {
        GameRouter(
            gameStamp: game,
            gameSettings: gameSettings,
            questionProvider: questionProvider,
            randomCodeProvider: randomCountryCodeProvider,
            remainingLives: remainingLives,
            store: storage
        )
    }

    // MARK: status
    
    func testThat_WhenTheGameIsCreated_ThenStatusIsIdle() async throws {
        // When
        let sut = self.makeSUT()
        
        var iterator = sut.pathObservable.values.makeAsyncIterator()
        let element = await iterator.next()
        let status = try XCTUnwrap(element)
        // Then
        XCTAssertTrue(status.isIdle)
    }
    
    // MARK: start
    
    func testThat_WhenGameIsStarted_ThenRancomCodeProvidedIsCalled() async {
        // When
        let store = StorageProtocolMock<UserChoice>()
        store.getAllElementsOfReturnValue = []
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        let sut = self.makeSUT(
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: store
        )

        // When
        await sut.start()
        
        // Then
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingCallsCount, 1)
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingReceivedExcluding, [])
    }
    
    func testThat_WhenGameIsStarted_ThenQuestionProviderIsCalled() async {
        // When
        let store = StorageProtocolMock<UserChoice>()
        store.getAllElementsOfReturnValue = []
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        var codeUsedToMakeQuestion: CountryCode?
        let questionProvider = { (country: CountryCode) in
            codeUsedToMakeQuestion = country
            return QuestionViewModelProtocolMock<MultipleChoiceViewModelProtocolMock>()
        }
        let sut = self.makeSUT(
            questionProvider: questionProvider,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: store
        )

        // When
        await sut.start()
        
        // Then
        XCTAssertEqual(codeUsedToMakeQuestion, "ES")
    }
    
    func testThat_WhenGameIsStarted_ThenStatusIsPlaying() async throws {
        // When
        let store = StorageProtocolMock<UserChoice>()
        store.getAllElementsOfReturnValue = []
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        var codeUsedToMakeQuestion: CountryCode?
        let providerQuestion = QuestionViewModelProtocolMock<MultipleChoiceViewModelProtocolMock>()
        let questionProvider = { (country: CountryCode) in
            codeUsedToMakeQuestion = country
            return providerQuestion
        }
        let remainingLives = RemainingLivesViewModelProtocolMock()
        let sut = self.makeSUT(
            questionProvider: questionProvider,
            randomCountryCodeProvider: randomCountryCodeProvider,
            remainingLives: remainingLives,
            storage: store
        )

        // When
        await sut.start()
        
        // Then
        XCTAssertEqual(codeUsedToMakeQuestion, "ES")
        var iterator = sut.pathObservable.values.makeAsyncIterator()
        let status = await iterator.next()
        let playingStatus = try XCTUnwrap(status?.playing)
        XCTAssertIdentical(playingStatus.question, providerQuestion)
        XCTAssertIdentical(playingStatus.lives, remainingLives)
    }
    
    // MARK: next
    
    func testThat_WhenGameNextIsCalled_ThenANewCountryIsFetchedExcludingAllCountrieCodesSoFar() async {
        // When
        let gameSettings = GameSettings.makeDouble(maxWrongAnwers: 3)
        let storage = StorageProtocolMock<UserChoice>()
        storage.getAllElementsOfReturnValue = [
            UserChoice.makeDouble(countryCode: "GR", pickedCountryCode: "GR"),
            UserChoice.makeDouble(countryCode: "IT", pickedCountryCode: "EN"),
            UserChoice.makeDouble(countryCode: "US", pickedCountryCode: "FR"),
            UserChoice.makeDouble(game: Date(timeIntervalSince1970: 1), countryCode: "CH", pickedCountryCode: "FR"),
        ]
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        let sut = self.makeSUT(
            game: Date(timeIntervalSince1970: 0),
            gameSettings: gameSettings,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: storage
        )

        // When
        await sut.gotNextQuestion()
        
        // Then
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingCallsCount, 1)
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingReceivedExcluding, ["GR", "IT", "US", "CH"])
    }
    
    func testThat_WhenGameNextIsCalled_ThenANewQuestionIsBuilt() async throws {
        // When
        let gameSettings = GameSettings.makeDouble(maxWrongAnwers: 3)
        let storage = StorageProtocolMock<UserChoice>()
        storage.getAllElementsOfReturnValue = []
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        var codeUsedToMakeQuestion: CountryCode?
        let providerQuestion = QuestionViewModelProtocolMock<MultipleChoiceViewModelProtocolMock>()
        let questionProvider = { (country: CountryCode) in
            codeUsedToMakeQuestion = country
            return providerQuestion
        }
        let remainingLives = RemainingLivesViewModelProtocolMock()
        let sut = self.makeSUT(
            game: Date(timeIntervalSince1970: 0),
            gameSettings: gameSettings,
            questionProvider: questionProvider,
            randomCountryCodeProvider: randomCountryCodeProvider,
            remainingLives: remainingLives,
            storage: storage
        )

        // When
        await sut.gotNextQuestion()
        
        // Then
        XCTAssertEqual(codeUsedToMakeQuestion, "ES")
        var iterator = sut.pathObservable.values.makeAsyncIterator()
        let status = await iterator.next()
        let playingStatus = try XCTUnwrap(status?.playing)
        XCTAssertIdentical(playingStatus.question, providerQuestion)
        XCTAssertIdentical(playingStatus.lives, remainingLives)
    }
    
    func testThat_WhenWronAnswersAreMoreThanAllowed_ThenIsGameOverWithTheRightScore() async throws {
        // When
        let gameSettings = GameSettings.makeDouble(maxWrongAnwers: 2)
        let storage = StorageProtocolMock<UserChoice>()
        storage.getAllElementsOfReturnValue = [
            UserChoice.makeDouble(countryCode: "GR", pickedCountryCode: "GR"),
            UserChoice.makeDouble(countryCode: "IT", pickedCountryCode: "EN"),
            UserChoice.makeDouble(countryCode: "US", pickedCountryCode: "FR"),
            UserChoice.makeDouble(game: Date(timeIntervalSince1970: 1), countryCode: "CH", pickedCountryCode: "FR"),
        ]
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        let sut = self.makeSUT(
            game: Date(timeIntervalSince1970: 0),
            gameSettings: gameSettings,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: storage
        )

        // When
        await sut.gotNextQuestion()
        
        // Then
        var iterator = sut.pathObservable.values.makeAsyncIterator()
        let status = await iterator.next()
        XCTAssertEqual(status?.gameOverScore, 1)
    }
}
