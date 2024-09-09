//
//  MultipleChoiceViewModelTests.swift
//  CoatOfArmsTests
//
//  Created on 17/8/24.
//

@testable import CoatOfArms
import Combine
import Network
import ReactiveStorage
import XCTest

final class MultipleChoiceViewModelTests: XCTestCase {
    
    // MARK: SUT
    
    func makeSUT(
        repository: MultipleChoiceRepositoryProtocolMock = .init()
    ) -> some MultipleChoiceViewModelProtocol {
        MultipleChoiceViewModel(
            gameSettings: .default,
            locale: Locale(identifier: "en_US"),
            outputScheduler: ImmediateScheduler.shared,
            repository: repository,
            nextAction: {}
        )
    }
    
    // MARK: viewWillAppear
    
    func testThat_WhenViewWillAppear_ThenMultipleChoiceIsFetched() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let expected = MultipleChoice.makeDouble()
        repo.multipleChoiceObservable = Just(expected).eraseToAnyPublisher()
        repo.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(repo.fetchAnswersCallsCount, 1)
    }
    
    func testThat_WhenViewWillAppear_ThenFormIsEnabled() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let expected = MultipleChoice.makeDouble()
        repo.multipleChoiceObservable = Just(expected).eraseToAnyPublisher()
        repo.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertTrue(sut.isEnabled)
    }
    
    // MARK: userDidHit
    
    func testThat_WhenUserDidHitButton_ThenAnswerIsSet() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let multipleChoice: MultipleChoice = MultipleChoice.makeDouble()
        repo.multipleChoiceObservable = Just(multipleChoice).eraseToAnyPublisher()
        repo.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.userDidHit(code: "es")
        
        // Then
        XCTAssertEqual(repo.setAnswerCallsCount, 1)
        XCTAssertEqual(repo.setAnswerReceivedAnswer, "es")
    }
    
    func testThat_WhenUserDidHitButton_ButtonSetIsDisabled() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let multipleChoice: MultipleChoice = MultipleChoice.makeDouble()
        repo.multipleChoiceObservable = Just(multipleChoice).eraseToAnyPublisher()
        repo.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.userDidHit(code: "es")
        
        // Then
        XCTAssertFalse(sut.isEnabled)
        
    }
    
    // MARK: rows
    
    func testThat_WhenMultipleChoiceIsNil_ThenButtonArrayIsEmpty() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        repo.multipleChoiceObservable = Just(nil).eraseToAnyPublisher()
        repo.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(sut.choiceButtons.map(\.id), [])
        XCTAssertEqual(sut.choiceButtons.map(\.label), [])
        XCTAssertEqual(sut.choiceButtons.map(\.effect), [])
    }
    
    func test_GivenStoredMultipleChoice_And_NoAnswer_WhenWillAppear_ThenButtonsAreAsExpected() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let multipleChoice: MultipleChoice = MultipleChoice.makeDouble(
            countryCode: "ES",
            otherChoices: ["IT", "AR"],
            rightChoicePosition: 0
        )
        repo.multipleChoiceObservable = Just(multipleChoice).eraseToAnyPublisher()
        repo.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(sut.choiceButtons.map(\.id), ["ES", "IT", "AR"])
        XCTAssertEqual(sut.choiceButtons.map(\.label), ["Spain", "Italy", "Argentina"])
        XCTAssertEqual(sut.choiceButtons.map(\.effect), [.none, .none, .none])
    }
    
    func test_GivenStoredMultipleChoice_And_WithWrongAnswer_WhenWillAppear_ThenButtonsAreAsExpected() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let multipleChoice: MultipleChoice = MultipleChoice.makeDouble(
            countryCode: "ES",
            otherChoices: ["IT", "AR"],
            rightChoicePosition: 0
        )
        repo.multipleChoiceObservable = Just(multipleChoice).eraseToAnyPublisher()
        let userChoice = UserChoice.makeDouble(
            countryCode: "ES",
            pickedCountryCode: "AR"
        )
        repo.userChoiceObservable = Just(userChoice).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(sut.choiceButtons.map(\.id), ["ES", "IT", "AR"])
        XCTAssertEqual(sut.choiceButtons.map(\.label), ["Spain", "Italy", "Argentina"])
        XCTAssertEqual(sut.choiceButtons.map(\.effect), [.none, .none, .wrongChoice])
    }
    
    func test_GivenStoredMultipleChoice_And_WithCorrectAnswer_WhenWillAppear_ThenButtonsAreAsExpected() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let multipleChoice: MultipleChoice = MultipleChoice.makeDouble(
            countryCode: "ES",
            otherChoices: ["IT", "AR"],
            rightChoicePosition: 0
        )
        repo.multipleChoiceObservable = Just(multipleChoice).eraseToAnyPublisher()
        let userChoice = UserChoice.makeDouble(
            countryCode: "ES",
            pickedCountryCode: "ES"
        )
        repo.userChoiceObservable = Just(userChoice).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(sut.choiceButtons.map(\.id), ["ES", "IT", "AR"])
        XCTAssertEqual(sut.choiceButtons.map(\.label), ["Spain", "Italy", "Argentina"])
        XCTAssertEqual(sut.choiceButtons.map(\.effect), [.rightChoice, .none, .none])
    }
}
