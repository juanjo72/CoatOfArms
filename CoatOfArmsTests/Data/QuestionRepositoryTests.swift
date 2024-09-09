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
        network: NetworkProtocolMock<ServerCountry> = .init(),
        storage: StorageProtocolMock<ServerCountry> = .init()
    ) -> QuestionRepository {
        QuestionRepository(
            countryCode: countryCode,
            network: network,
            storage: storage
        )
    }
    
    // MARK: fetchCountry
    
    func testThat_WhenCountryIsFetched_ThenRequestIsSent() async throws {
        // Given
        let network = NetworkProtocolMock<ServerCountry>()
        let returnCountry = ServerCountry.makeDouble()
        network.requestUrlDecoderReturnValue = returnCountry
        let sut = self.makeMock(
            network: network
        )
        
        // When
        try await sut.fetchCountry()
        
        // Then
        XCTAssertEqual(network.requestUrlDecoderCallsCount, 1)
    }
    
    func testThat_WhenCountryIsFetched_AndRequestFails_ThenThrowsError() async {
        // Given
        let network = NetworkProtocolMock<ServerCountry>()
        network.requestUrlDecoderThrowableError = DecodeError.empty
        let sut = self.makeMock(
            network: network
        )
        
        do {
            try await sut.fetchCountry()
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testThat_WhenCountryIsFetched_ThenResponseIsStored() async throws {
        // Given
        let network = NetworkProtocolMock<ServerCountry>()
        let store = StorageProtocolMock<ServerCountry>()
        let returnCountry = ServerCountry.makeDouble()
        network.requestUrlDecoderReturnValue = returnCountry
        let sut = self.makeMock(
            countryCode: "ES",
            network: network,
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
        let store = StorageProtocolMock<ServerCountry>()
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
