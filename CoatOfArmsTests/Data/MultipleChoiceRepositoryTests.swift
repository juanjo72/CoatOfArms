//
//  MultipleChoiceRepositoryTests.swift
//  CoatOfArmsTests
//
//  Created on 17/8/24.
//

@testable import CoatOfArms
import Combine
import XCTest

final class MultipleChoiceRepositoryTests: XCTestCase {
    
    // MARK: SUT
    
    private func makeSUT(
        id: MultipleChoice.ID = .init(game: Date(), countryCode: "ES"),
        gameSettings: GameSettings = .default,
        randomCountryCodeProvider: RandomCountryCodeProviderProtocol = RandomCountryCodeProviderProtocolMock(),
        storage: StorageProtocol = StorageProtocolMock<ServerCountry>()
    ) -> MultipleChoiceRepository {
        MultipleChoiceRepository(
            id: id,
            gameSettings: gameSettings,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: storage
        )
    }
    
    // MARK: fetchAnswers
    
    func testThat_WhenMultipleChoiceIsFetched_ThenIsCreatedAndStored() async throws {
        // Given
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodesNExcludingReturnValue = ["UK", "AR", "US"]
        let store = StorageProtocolMock<MultipleChoice>()
        let sut = self.makeSUT(
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: store
        )
        
        // When
        await sut.fetchAnswers()
        
        // Then
        XCTAssertEqual(store.addCallsCount, 1)
        XCTAssertEqual(store.addReceivedElement?.id.countryCode, "ES")
        XCTAssertEqual(store.addReceivedElement?.otherChoices, ["UK", "AR", "US"])
        let rightChoicePosition = try XCTUnwrap(store.addReceivedElement?.rightChoicePosition)
        XCTAssertLessThan(rightChoicePosition, 4)
    }
    
    func testThat_WhenAnswerIsSet_ThenUserChoiceIsStored() async {
        // Given
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodesNExcludingReturnValue = ["UK", "AR", "US"]
        let store = StorageProtocolMock<UserChoice>()
        let sut = self.makeSUT(
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: store
        )
        
        // When
        await sut.set(answer: "UK")
        
        // Then
        XCTAssertEqual(store.addCallsCount, 1)
        XCTAssertEqual(store.addReceivedElement?.id.countryCode, "ES")
        XCTAssertEqual(store.addReceivedElement?.pickedCountryCode, "UK")
    }
    
    // MARK: multipleChoiceObservable
    
    func testThat_WhenMultipleChoiceIsObserved_ThenStoredValueIsSent() {
        // Given
        let store = StorageProtocolMock<MultipleChoice>()
        let returnValue = MultipleChoice.makeDouble()
        store.getSingleElementObservableOfIdReturnValue = Just(returnValue).eraseToAnyPublisher()
        let sut = self.makeSUT(storage: store)
        
        // When
        var observed: MultipleChoice?
        let _ = sut.multipleChoiceObservable
            .sink { observed = $0 }
        
        // Then
        XCTAssertEqual(store.getSingleElementObservableOfIdCallsCount, 1)
        XCTAssertEqual(store.getSingleElementObservableOfIdReceivedArguments?.id.countryCode, "ES")
        XCTAssertEqual(observed, returnValue)
    }
    
    // MARK: storedAnswerObservable
    
    func testThat_WhenStoredAnswerIsObserved_ThenStoredValueIsSent() {
        // Given
        let store = StorageProtocolMock<UserChoice>()
        let returnValue = UserChoice.makeDouble()
        store.getSingleElementObservableOfIdReturnValue = Just(returnValue).eraseToAnyPublisher()
        let sut = self.makeSUT(storage: store)
        
        // When
        var observed: UserChoice?
        let _ = sut.userChoiceObservable
            .sink { observed = $0 }
        
        // Then
        XCTAssertEqual(store.getSingleElementObservableOfIdCallsCount, 1)
        XCTAssertEqual(store.getSingleElementObservableOfIdReceivedArguments?.id.countryCode, "ES")
        XCTAssertEqual(observed, returnValue)
    }
}
