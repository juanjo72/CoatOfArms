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

final class MultipleChoiceRepositoryTests: XCTestCase {
    
    // MARK: SUT
    
    private func makeSUT(
        countryCode: CountryCode = "es",
        countryProvider: CountryCodeProviderProtocol = CountryCodeProviderProtocolMock(),
        gameSettings: GameSettings = .init(numPossibleChoices: 3),
        storage: ReactiveStorage.ReactiveStorageProtocol = ReactiveStorageProtocolMock<Country>()
    ) -> MultipleChoiceRepository {
        MultipleChoiceRepository(
            countryCode: countryCode,
            countryCodeProvider: countryProvider,
            gameSettings: gameSettings,
            storage: storage
        )
    }
    
    // MARK: fetchAnswers
    
    func testThat_WhenMultipleChoiceIsFetched_ThenIsCreatedAndStored() async throws {
        // Given
        let countryProvider = CountryCodeProviderProtocolMock()
        countryProvider.generateCodesNExcludingReturnValue = ["uk", "ar"]
        let store = ReactiveStorageProtocolMock<MultipleChoice>()
        let sut = self.makeSUT(
            countryCode: "es",
            countryProvider: countryProvider,
            gameSettings: .init(numPossibleChoices: 3),
            storage: store
        )
        
        // When
        await sut.fetchAnswers()
        
        // Then
        XCTAssertEqual(store.addCallsCount, 1)
        XCTAssertEqual(store.addReceivedElement?.id, "es")
        XCTAssertEqual(store.addReceivedElement?.otherChoices, ["uk", "ar"])
        let rightChoicePosition = try XCTUnwrap(store.addReceivedElement?.rightChoicePosition)
        XCTAssertLessThan(rightChoicePosition, 3)
    }
    
    func testThat_WhenAnswerIsSet_ThenUserChoiceIsStored() async {
        // Given
        let countryProvider = CountryCodeProviderProtocolMock()
        countryProvider.generateCodesNExcludingReturnValue = ["uk", "ar"]
        let store = ReactiveStorageProtocolMock<UserChoice>()
        let sut = self.makeSUT(
            countryCode: "es",
            countryProvider: countryProvider,
            gameSettings: .init(numPossibleChoices: 3),
            storage: store
        )
        
        // When
        await sut.set(answer: "uk")
        
        // Then
        XCTAssertEqual(store.addCallsCount, 1)
        XCTAssertEqual(store.addReceivedElement?.id, "es")
        XCTAssertEqual(store.addReceivedElement?.pickedCountryCode, "uk")
    }
    
    // MARK: multipleChoiceObservable
    
    func testThat_WhenMultipleChoiceIsObserved_ThenStoredValueIsSent() {
        // Given
        let store = ReactiveStorageProtocolMock<MultipleChoice>()
        let returnValue = MultipleChoice(id: "es", otherChoices: ["uk", "ar"], rightChoicePosition: 0)
        store.getSingleElementObservableOfIdReturnValue = Just(returnValue).eraseToAnyPublisher()
        let sut = self.makeSUT(storage: store)
        
        // When
        var observed: MultipleChoice?
        let _ = sut.multipleChoiceObservable()
            .sink { observed = $0 }
        
        // Then
        XCTAssertEqual(store.getSingleElementObservableOfIdCallsCount, 1)
        XCTAssertEqual(store.getSingleElementObservableOfIdReceivedArguments?.id, "es")
        XCTAssertEqual(observed, returnValue)
    }
    
    // MARK: storedAnswerObservable
    
    func testThat_WhenStoredAnswerIsObserved_ThenStoredValueIsSent() {
        // Given
        let store = ReactiveStorageProtocolMock<UserChoice>()
        let returnValue = UserChoice(id: "es", pickedCountryCode: "uk")
        store.getSingleElementObservableOfIdReturnValue = Just(returnValue).eraseToAnyPublisher()
        let sut = self.makeSUT(storage: store)
        
        // When
        var observed: UserChoice?
        let _ = sut.storedAnswerObservable()
            .sink { observed = $0 }
        
        // Then
        XCTAssertEqual(store.getSingleElementObservableOfIdCallsCount, 1)
        XCTAssertEqual(store.getSingleElementObservableOfIdReceivedArguments?.id, "es")
        XCTAssertEqual(observed, returnValue)
    }
}
