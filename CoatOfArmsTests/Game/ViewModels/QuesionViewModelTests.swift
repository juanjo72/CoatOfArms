//
//  QuesionViewModelTests.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

@testable import CoatOfArms
import Combine
import Foundation
import Testing

@Suite("QuestionViewModel", .tags(.logicLayer))
struct QuestionViewModelTests {
    
    // MARK: SUT
    
    private func makeSUT(
        countryCode: CountryCode = "ES",
        buttonProvider: @escaping (CountryCode) -> ChoiceButtonViewModelProtocolMock = { _ in .init() },
        repository: QuestionRepositoryProtocolMock = .init(),
        router: GameRouterProtocolMock = .init()
    ) -> QuestionViewModel<ChoiceButtonViewModelProtocolMock, ImmediateScheduler> {
        QuestionViewModel(
            countryCode: countryCode,
            buttonProvider: buttonProvider,
            outputScheduler: ImmediateScheduler.shared,
            repository: repository,
            router: router
        )
    }
    
    // MARK: viewWillAppear
    
    @Test("Fetching question")
    func testThat_WhenWillAppear_ThenQuestionIsFetched() async throws {
        // MARK: Given
        let repository = QuestionRepositoryProtocolMock()
        repository.questionObservable = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repository
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        #expect(repository.fetchQuestionCallsCount == 1)
    }
    
    @Test("State loading")
    func testThat_WhenWillAppear_StateIsLoading() async throws {
        // MARK: Given
        let repository = QuestionRepositoryProtocolMock()
        repository.questionObservable = Just(nil).eraseToAnyPublisher()
        let sut = self.makeSUT(
            repository: repository
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        #expect(sut.loadingState.isLoading)
    }
    
    @Test("Observed question")
    func testThat_GivenObservedQuestion_WhenCreated_ThenStatusElementMatchesQuestion() async throws {
        // MARK: Given
        var codes = [CountryCode]()
        let buttonProvider: (CountryCode) -> ChoiceButtonViewModelProtocolMock = { code in
            codes.append(code)
            return ChoiceButtonViewModelProtocolMock()
        }

        let repository = QuestionRepositoryProtocolMock()
        let expectedURL = URL(string: "https://mainfacts.com/media/images/coats_of_arms/es.png")!
        let observedQuestion = Question.make(
            coatOfArmsURL: expectedURL,
            otherChoices: ["IT", "DE", "FR"],
            rightChoicePosition: 1
        )
        repository.questionObservable = Just(observedQuestion).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            buttonProvider: buttonProvider,
            repository: repository
        )
        
        // Then
        #expect(sut.loadingState.element?.imageURL == expectedURL)
        #expect(codes == ["IT", "ES", "DE", "FR"])
    }
    
    // MARK: Error handling
    
    @Test("Coat of arms not found")
    func testThat_WhenWillAppear_And_FetchReturnsDecodingError_TheNextQuestionIsCalled() async throws {
        // Given
        let repository = QuestionRepositoryProtocolMock()
        repository.questionObservable = Just(nil).eraseToAnyPublisher()
        let router = GameRouterProtocolMock()
        let error = DecodingError.keyNotFound(
            ServerCountry.CoatOfArms.png,
            DecodingError.Context(codingPath: [ServerCountry.CodingKeys.coatOfArms], debugDescription: "")
        )
        repository.fetchQuestionThrowableError = error
        let sut = self.makeSUT(
            repository: repository,
            router: router
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        #expect(router.gotNextQuestionCallsCount == 1)
    }
    
    @Test("No connection")
    func testThat_WhenFetchReturnsOtherError_TheShowErrorIsCalled() async throws {
        // Given
        let repository = QuestionRepositoryProtocolMock()
        repository.questionObservable = Just(nil).eraseToAnyPublisher()
        let router = GameRouterProtocolMock()
        let error = Foundation.URLError(.notConnectedToInternet)
        repository.fetchQuestionThrowableError = error
        let sut = self.makeSUT(
            repository: repository,
            router: router
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        #expect(router.showMessageActionCallsCount == 1)
    }
}
