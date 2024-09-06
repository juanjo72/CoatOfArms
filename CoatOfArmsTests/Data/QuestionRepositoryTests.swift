//
//  QuestionRepositoryTests.swift
//  CoatOfArmsTests
//
//  Created on 12/8/24.
//

@testable import CoatOfArms
import Combine
import XCTest

final class QuestionRepositoryTests: XCTestCase {
    
    // MARK: SUT
    
    func makeMock(
        countryCode: String = "ES",
        requestSender: RequestSenderProtocolMock<ServerCountry> = .init(),
        storage: ReactiveStorageProtocolMock<ServerCountry> = .init()
    ) -> QuestionRepository {
        QuestionRepository(
            countryCode: countryCode,
            requestSender: requestSender,
            storage: storage
        )
    }
    
    // MARK: fetchCountry
    
    func testThat_WhenCountryIsFetched_ThenRequestIsSent() async throws {
        // Given
        let sender = RequestSenderProtocolMock<ServerCountry>()
        let returnCountry = ServerCountry.makeDouble()
        sender.requestResourceReturnValue = returnCountry
        let sut = self.makeMock(
            requestSender: sender
        )
        
        // When
        try await sut.fetchCountry()
        
        // Then
        XCTAssertEqual(sender.requestResourceCallsCount, 1)
    }
    
    func testThat_WhenCountryIsFetched_AndRequestFails_ThenThrowsError() async {
        // Given
        let sender = RequestSenderProtocolMock<ServerCountry>()
        sender.requestResourceThrowableError = DecodeError.empty
        let sut = self.makeMock(
            requestSender: sender
        )
        
        do {
            try await sut.fetchCountry()
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testThat_WhenCountryIsFetched_ThenResponseIsStored() async throws {
        // Given
        let sender = RequestSenderProtocolMock<ServerCountry>()
        let store = ReactiveStorageProtocolMock<ServerCountry>()
        let returnCountry = ServerCountry.makeDouble()
        sender.requestResourceReturnValue = returnCountry
        let sut = self.makeMock(
            countryCode: "ES",
            requestSender: sender,
            storage: store
        )
        
        // When
        try await sut.fetchCountry()
        
        // Then
        XCTAssertEqual(store.addCallsCount, 1)
        XCTAssertEqual(store.addReceivedElement, returnCountry)
    }
    
    // MARK: countryObservable
    
    func testThat_WhenSubscribedToCountryID_ThenCountryIsObserved() {
        // Given
        let store = ReactiveStorageProtocolMock<ServerCountry>()
        let returnCountry = ServerCountry.makeDouble()
        store.getSingleElementObservableOfIdReturnValue = Just(returnCountry).eraseToAnyPublisher()
        let sut = self.makeMock(storage: store)
        
        // When
        var observed: ServerCountry?
        let _ = sut.countryObservable
            .sink { observed = $0 }
        
        // Then
        XCTAssertEqual(store.getSingleElementObservableOfIdCallsCount, 1)
        XCTAssertEqual(store.getSingleElementObservableOfIdReceivedArguments?.id, "ES")
        XCTAssertEqual(observed, returnCountry)
    }
}
