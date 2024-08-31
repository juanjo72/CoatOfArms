//
//  File.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 17/8/24.
//

@testable import CoatOfArms
import Combine
import Network
import ReactiveStorage
import XCTest

final class MultipleChoiceViewModelTests: XCTestCase {
    
    // MARK: SUT
    
    func makeSUT(
        repository: MultipleChoiceRepositoryProtocolMock = .init(),
        router: GameRouterProtocolMock = .init()
    ) -> some MultipleChoiceViewModelProtocol {
        MultipleChoiceViewModel(
            gameSettings: .default,
            outputScheduler: ImmediateScheduler.shared,
            repository: repository,
            router: router
        )
    }
    
    // MARK: viewWillAppear
    
    func testThat_WhenViewWillAppear_ThenMultipleChoiceIsFetched() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let expected = MultipleChoice.makeDouble()
        repo.multipleChoiceObservableReturnValue = Just(expected).eraseToAnyPublisher()
        repo.storedAnswerObservableReturnValue = Just(nil).eraseToAnyPublisher()
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
        repo.multipleChoiceObservableReturnValue = Just(expected).eraseToAnyPublisher()
        repo.storedAnswerObservableReturnValue = Just(nil).eraseToAnyPublisher()
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
        let multipleChoice: MultipleChoice = MultipleChoice(id: "es", otherChoices: ["uk", "ar"], rightChoicePosition: 0)
        repo.multipleChoiceObservableReturnValue = Just(multipleChoice).eraseToAnyPublisher()
        repo.storedAnswerObservableReturnValue = Just(nil).eraseToAnyPublisher()
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
        let multipleChoice: MultipleChoice = MultipleChoice(id: "es", otherChoices: ["uk", "ar"], rightChoicePosition: 0)
        repo.multipleChoiceObservableReturnValue = Just(multipleChoice).eraseToAnyPublisher()
        repo.storedAnswerObservableReturnValue = Just(nil).eraseToAnyPublisher()
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
        repo.multipleChoiceObservableReturnValue = Just(nil).eraseToAnyPublisher()
        repo.storedAnswerObservableReturnValue = Just(nil).eraseToAnyPublisher()
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
        let multipleChoice: MultipleChoice = MultipleChoice(id: "es", otherChoices: ["uk", "ar"], rightChoicePosition: 0)
        repo.multipleChoiceObservableReturnValue = Just(multipleChoice).eraseToAnyPublisher()
        repo.storedAnswerObservableReturnValue = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(sut.choiceButtons.map(\.id), ["es", "uk", "ar"])
        XCTAssertEqual(sut.choiceButtons.map(\.label), ["Spain", "United Kingdom", "Argentina"])
        XCTAssertEqual(sut.choiceButtons.map(\.effect), [.none, .none, .none])
    }
    
    func test_GivenStoredMultipleChoice_And_WithWrongAnswer_WhenWillAppear_ThenButtonsAreAsExpected() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let multipleChoice: MultipleChoice = MultipleChoice(id: "es", otherChoices: ["uk", "ar"], rightChoicePosition: 0)
        repo.multipleChoiceObservableReturnValue = Just(multipleChoice).eraseToAnyPublisher()
        let userChoice = UserChoice(id: "es", pickedCountryCode: "ar")
        repo.storedAnswerObservableReturnValue = Just(userChoice).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(sut.choiceButtons.map(\.id), ["es", "uk", "ar"])
        XCTAssertEqual(sut.choiceButtons.map(\.label), ["Spain", "United Kingdom", "Argentina"])
        XCTAssertEqual(sut.choiceButtons.map(\.effect), [.none, .none, .wrongChoice])
    }
    
    func test_GivenStoredMultipleChoice_And_WithCorrectAnswer_WhenWillAppear_ThenButtonsAreAsExpected() async {
        // Given
        let repo = MultipleChoiceRepositoryProtocolMock()
        let multipleChoice: MultipleChoice = MultipleChoice(id: "es", otherChoices: ["uk", "ar"], rightChoicePosition: 0)
        repo.multipleChoiceObservableReturnValue = Just(multipleChoice).eraseToAnyPublisher()
        let userChoice = UserChoice(id: "es", pickedCountryCode: "es")
        repo.storedAnswerObservableReturnValue = Just(userChoice).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repo
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(sut.choiceButtons.map(\.id), ["es", "uk", "ar"])
        XCTAssertEqual(sut.choiceButtons.map(\.label), ["Spain", "United Kingdom", "Argentina"])
        XCTAssertEqual(sut.choiceButtons.map(\.effect), [.rightChoice, .none, .none])
    }
}
