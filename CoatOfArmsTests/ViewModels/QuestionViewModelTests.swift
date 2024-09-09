//
//  WhichCountryViewModelTests.swift
//  CoatOfArmsTests
//
//  Created on 19/8/24.
//

@testable import CoatOfArms
import Combine
import Network
import ReactiveStorage
import XCTest

final class QuestionViewModelTests: XCTestCase {
    
    // MARK: SUT
    
    private func makeSUT(
        countryCode: CountryCode = "ES",
        multipleChoiceProvider: @escaping () -> some MultipleChoiceViewModelProtocolMock = { MultipleChoiceViewModelProtocolMock() },
        remoteImagePrefetcher: @escaping (URL) -> AnyPublisher<Bool, Never> = { _ in Just(true).eraseToAnyPublisher() },
        repository: QuestionRepositoryProtocolMock = .init(),
        nextAction: @escaping () async -> Void = {}
    ) -> some QuestionViewModelProtocol {
        QuestionViewModel(
            countryCode: countryCode,
            multipleChoiceProvider: multipleChoiceProvider,
            outputScheduler: ImmediateScheduler.shared,
            remoteImagePrefetcher: remoteImagePrefetcher,
            repository: repository,
            nextAction: nextAction
        )
    }
    
    // viewWillAppear
    
    func testThat_WhenViewWillAppear_ThenCountryIsFetched() async {
        // Given
        let repository = QuestionRepositoryProtocolMock()
        repository.countryObservable = Just(nil).eraseToAnyPublisher()
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
    
    func testThat_WhenViewWillAppear_ThenMultipleChoiceIsAssigned() async throws {
        // Given
        let repository = QuestionRepositoryProtocolMock()
        repository.countryObservable = Just(.makeDouble()).eraseToAnyPublisher()
        let expectedMultipleChoice = MultipleChoiceViewModelProtocolMock()
        
        // When
        let sut = self.makeSUT(
            multipleChoiceProvider: { expectedMultipleChoice },
            repository: repository
        )
        
        // Then
        let element = try XCTUnwrap(sut.loadingState.element)
        let multipleChoice = try XCTUnwrap(element.multipleChoice)
        XCTAssertIdentical(expectedMultipleChoice, multipleChoice)
    }
    
    // MARK:
    
    func testThat_WhenCreated_ThenQuestionIsNull() throws {
        // Given
        let repository = QuestionRepositoryProtocolMock()
        repository.countryObservable = Just(nil).eraseToAnyPublisher()
        let multipleChoice = MultipleChoiceViewModelProtocolMock()
        
        // When
        let sut = self.makeSUT(
            multipleChoiceProvider: { multipleChoice },
            repository: repository
        )
        
        // Then
        XCTAssertNil(sut.loadingState.element)
    }
    
    func testThat_GivenStoredCountry_WhenCreated_ThenURLIsPublished() async throws {
        // Given
        let repository = QuestionRepositoryProtocolMock()
        let returnCountry = ServerCountry.makeDouble()
        repository.countryObservable = Just(returnCountry).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            repository: repository
        )
        
        // Then
        let element = try XCTUnwrap(sut.loadingState.element)
        XCTAssertEqual(element.imageURL, returnCountry.coatOfArmsURL)
    }
}
