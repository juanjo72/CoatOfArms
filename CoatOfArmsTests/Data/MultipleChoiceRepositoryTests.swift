//
//  MultipleChoiceRepositoryTests.swift
//  CoatOfArmsTests
//
//  Created on 17/8/24.
//

@testable import CoatOfArms
import Combine
import Network
import ReactiveStorage
import XCTest

final class MultipleChoiceRepositoryTests: XCTestCase {
    
    // MARK: SUT
    
    private func makeSUT(
        countryCode: CountryCode = "ES",
        countryProvider: RandomCountryCodeProviderProtocol = RandomCountryCodeProviderProtocolMock(),
        gameSettings: GameSettings = .default,
        storage: ReactiveStorage.ReactiveStorageProtocol = ReactiveStorageProtocolMock<ServerCountry>()
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
        let countryProvider = RandomCountryCodeProviderProtocolMock()
        countryProvider.generateCodesNExcludingReturnValue = ["UK", "AR", "US"]
        let gameSettings = GameSettings(
            numPossibleChoices: 4,
            resultTime: .seconds(1),
            maxWrongAnswers: 3
        )
        let store = ReactiveStorageProtocolMock<MultipleChoice>()
        let sut = self.makeSUT(
            countryCode: "ES",
            countryProvider: countryProvider,
            gameSettings: .default,
            storage: store
        )
        
        // When
        await sut.fetchAnswers()
        
        // Then
        XCTAssertEqual(store.addCallsCount, 1)
        XCTAssertEqual(store.addReceivedElement?.id, "ES")
        XCTAssertEqual(store.addReceivedElement?.otherChoices, ["UK", "AR", "US"])
        let rightChoicePosition = try XCTUnwrap(store.addReceivedElement?.rightChoicePosition)
        XCTAssertLessThan(rightChoicePosition, 4)
    }
    
    func testThat_WhenAnswerIsSet_ThenUserChoiceIsStored() async {
        // Given
        let countryProvider = RandomCountryCodeProviderProtocolMock()
        countryProvider.generateCodesNExcludingReturnValue = ["UK", "AR", "US"]
        let store = ReactiveStorageProtocolMock<UserChoice>()
        let sut = self.makeSUT(
            countryCode: "ES",
            countryProvider: countryProvider,
            gameSettings: .default,
            storage: store
        )
        
        // When
        await sut.set(answer: "UK")
        
        // Then
        XCTAssertEqual(store.addCallsCount, 1)
        XCTAssertEqual(store.addReceivedElement?.id, "ES")
        XCTAssertEqual(store.addReceivedElement?.pickedCountryCode, "UK")
    }
    
    // MARK: multipleChoiceObservable
    
    func testThat_WhenMultipleChoiceIsObserved_ThenStoredValueIsSent() {
        // Given
        let store = ReactiveStorageProtocolMock<MultipleChoice>()
        let returnValue = MultipleChoice(id: "ES", otherChoices: ["UK", "AR", "US"], rightChoicePosition: 0)
        store.getSingleElementObservableOfIdReturnValue = Just(returnValue).eraseToAnyPublisher()
        let sut = self.makeSUT(storage: store)
        
        // When
        var observed: MultipleChoice?
        let _ = sut.multipleChoiceObservable()
            .sink { observed = $0 }
        
        // Then
        XCTAssertEqual(store.getSingleElementObservableOfIdCallsCount, 1)
        XCTAssertEqual(store.getSingleElementObservableOfIdReceivedArguments?.id, "ES")
        XCTAssertEqual(observed, returnValue)
    }
    
    // MARK: storedAnswerObservable
    
    func testThat_WhenStoredAnswerIsObserved_ThenStoredValueIsSent() {
        // Given
        let store = ReactiveStorageProtocolMock<UserChoice>()
        let returnValue = UserChoice(id: "ES", pickedCountryCode: "UK")
        store.getSingleElementObservableOfIdReturnValue = Just(returnValue).eraseToAnyPublisher()
        let sut = self.makeSUT(storage: store)
        
        // When
        var observed: UserChoice?
        let _ = sut.storedAnswerObservable()
            .sink { observed = $0 }
        
        // Then
        XCTAssertEqual(store.getSingleElementObservableOfIdCallsCount, 1)
        XCTAssertEqual(store.getSingleElementObservableOfIdReceivedArguments?.id, "ES")
        XCTAssertEqual(observed, returnValue)
    }
}
