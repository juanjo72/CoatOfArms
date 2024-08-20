//
//  WhichCountryViewModelTests.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 19/8/24.
//

@testable import CoatOfArms
import Combine
import Network
import ReactiveStorage
import XCTest

final class WhichCountryViewModelTests: XCTestCase {
    
    // MARK: SUT
    
    private func makeSUT(
        multipleChoiceProvider: @escaping () -> some MultipleChoiceViewModelProtocolMock = { MultipleChoiceViewModelProtocolMock() },
        repository: WhichCountryRepostoryProtocol
    ) -> WhichCountryViewModel<MultipleChoiceViewModelProtocolMock> {
        WhichCountryViewModel(
            multipleChoiceProvider: multipleChoiceProvider,
            repository: repository
        )
    }
    
    // viewWillAppear
    
    func testThat_WhenViewWillAppear_ThenCountryIsFetched() async {
        // Given
        let repository = WhichCountryRepostoryProtocolMock()
        repository.countryObservableReturnValue = Just(nil).eraseToAnyPublisher()
        let multipleChoice = MultipleChoiceViewModelProtocolMock()
        let sut = self.makeSUT(
            multipleChoiceProvider: { multipleChoice },
            repository: repository
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertEqual(repository.fetchCountryCallsCount, 1)
    }
    
    func testThat_WhenViewWillAppear_ThenMultipleChoiceIsAssigned() async {
        // Given
        let repository = WhichCountryRepostoryProtocolMock()
        repository.countryObservableReturnValue = Just(nil).eraseToAnyPublisher()
        let multipleChoice = MultipleChoiceViewModelProtocolMock()
        let sut = self.makeSUT(
            multipleChoiceProvider: { multipleChoice },
            repository: repository
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        XCTAssertIdentical(sut.multipleChoice, multipleChoice)
    }
    
    // MARK:
    
    func testThat_WhenCreated_ThenBothImageAndMultipleChoiceIsNull() {
        // Given
        let repository = WhichCountryRepostoryProtocolMock()
        repository.countryObservableReturnValue = Just(nil).eraseToAnyPublisher()
        let multipleChoice = MultipleChoiceViewModelProtocolMock()
        
        // When
        let sut = self.makeSUT(
            multipleChoiceProvider: { multipleChoice },
            repository: repository
        )
        
        // Then
        XCTAssertNil(sut.imageURL)
        XCTAssertNil(sut.multipleChoice)
    }
    
    func testThat_GivenStoredCountry_WhenCreated_ThenURLIsPublished() async {
        // Given
        let repository = WhichCountryRepostoryProtocolMock()
        let returnCountry = Country.makeDouble()
        repository.countryObservableReturnValue = Just(returnCountry).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            repository: repository
        )
        
        // Then
        XCTAssertEqual(sut.imageURL, returnCountry.coatOfArmsURL)
    }
}
