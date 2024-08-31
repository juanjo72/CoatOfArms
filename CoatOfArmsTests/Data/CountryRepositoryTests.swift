//
//  WhichCountryRepositoryTests.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 12/8/24.
//

@testable import CoatOfArms
import Combine
import Network
import ReactiveStorage
import XCTest

final class CountryRepositoryTests: XCTestCase {
    
    // MARK: SUT
    
    func makeMock(
        countryCode: String = "es",
        requestSender: Network.RequestSenderProtocol = RequestSenderProtocolMock<Country>(),
        storage: ReactiveStorage.ReactiveStorageProtocol = ReactiveStorageProtocolMock<Country>()
    ) -> CountryRepository {
        CountryRepository(
            countryCode: countryCode,
            requestSender: requestSender,
            storage: storage
        )
    }
    
    // MARK: fetchCountry

    func testThat_WhenCountryIsFetched_ThenResponseIsStored() async throws {
        // Given
        let sender = RequestSenderProtocolMock<Country>()
        let store = ReactiveStorageProtocolMock<Country>()
        let returnCountry = Country(id: "es", coatOfArmsURL: URL(string: "http://www.google.com")!)
        sender.requestResourceReturnValue = returnCountry
        let sut = self.makeMock(requestSender: sender, storage: store)
        
        // When
        try await sut.fetchCountry()
        
        // Then
        XCTAssertEqual(sender.requestResourceCallsCount, 1)
        XCTAssertEqual(store.addCallsCount, 1)
        XCTAssertEqual(store.addReceivedElement, returnCountry)
    }
    
    // MARK: countryObservable
    
    func testThat_WhenSubscribedToCountryID_ThenCountryIsObserved() {
        // Given
        let store = ReactiveStorageProtocolMock<Country>()
        let returnCountry = Country(id: "es", coatOfArmsURL: URL(string: "http://www.google.com")!)
        store.getSingleElementObservableOfIdReturnValue = Just(returnCountry).eraseToAnyPublisher()
        let sut = self.makeMock(storage: store)
        
        // When
        var observed: Country?
        let _ = sut.countryObservable()
            .sink { observed = $0 }
        
        // Then
        XCTAssertEqual(store.getSingleElementObservableOfIdCallsCount, 1)
        XCTAssertEqual(store.getSingleElementObservableOfIdReceivedArguments?.id, "es")
        XCTAssertEqual(observed, returnCountry)
    }
}
