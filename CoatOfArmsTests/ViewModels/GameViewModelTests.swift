//
//  GameViewModelTests.swift
//  CoatOfArmsTests
//
//  Created on 8/9/24.
//
    
@testable import CoatOfArms
import Combine
import XCTest

final class GameViewModelTests: XCTestCase {

    // MARK: SUT
    
    private func makeSUT(
        game: GameStamp = Date(timeIntervalSince1970: 0),
        gameSettings: GameSettings = .default,
        questionProvider: @escaping (CountryCode) -> some QuestionViewModelProtocol = { _ in QuestionViewModelProtocolMock<MultipleChoiceViewModelProtocolMock>() },
        randomCountryCodeProvider: RandomCountryCodeProviderProtocolMock = .init(),
        remainingLives: RemainingLivesViewModelProtocolMock = .init(),
        storage: StorageProtocolMock<UserChoice> = .init()
    ) -> some GameViewModelProtocol {
        GameViewModel(
            game: game,
            gameSettings: gameSettings,
            outputScheduler: ImmediateScheduler.shared,
            questionProvider: questionProvider,
            randomCountryCodeProvider: randomCountryCodeProvider,
            remainingLives: remainingLives,
            storage: storage)
    }

    // MARK: status
    
    func testThat_WhenTheGameIsCreated_ThenStatusIsIdle() {
        // When
        let sut = self.makeSUT()
        
        // Then
        XCTAssertTrue(sut.status.isIdle)
    }
    
    // MARK: start
    
    func testThat_WhenGameIsStarted_ThenRancomCodeProvidedIsCalled() {
        // When
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        let sut = self.makeSUT(
            randomCountryCodeProvider: randomCountryCodeProvider
        )

        // When
        sut.start()
        
        // Then
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingCallsCount, 1)
        XCTAssertEqual(randomCountryCodeProvider.generateCodeExcludingReceivedExcluding, [])
    }
    
    func testThat_WhenGameIsStarted_ThenQuestionProviderIsCalled() {
        // When
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodeExcludingReturnValue = "ES"
        var codeUsedToMakeQuestion: CountryCode?
        let questionProvider = { (country: CountryCode) in
            codeUsedToMakeQuestion = country
            return QuestionViewModelProtocolMock<MultipleChoiceViewModelProtocolMock>()
        }
        let sut = self.makeSUT(
            questionProvider: questionProvider,
            randomCountryCodeProvider: randomCountryCodeProvider
        )

        // When
        sut.start()
        
        // Then
        XCTAssertEqual(codeUsedToMakeQuestion, "ES")
    }
    
    func testThat_WhenGameIsStarted_ThenStatusIsPlaying() throws {
        // When
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
            remainingLives: remainingLives
        )

        // When
        sut.start()
        
        // Then
        XCTAssertEqual(codeUsedToMakeQuestion, "ES")
        let playingStatus = try XCTUnwrap(sut.status.playing)
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
        await sut.next()
        
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
        await sut.next()
        
        // Then
        XCTAssertEqual(codeUsedToMakeQuestion, "ES")
        let playingStatus = try XCTUnwrap(sut.status.playing)
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
        await sut.next()
        
        // Then
        XCTAssertEqual(sut.status.gameOverScore, 1)
    }
}
