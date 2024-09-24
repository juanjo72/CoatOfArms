//
//  QuestionRepositoryTests.swift
//  CoatOfArmsTests
//
//  Created on 22/9/24.
//

@testable import CoatOfArms
import Combine
import Foundation
import MockableTest
import Testing

@Suite("QuestionRepository", .tags(.dataLayer))
struct QuestionRepositoryTests {
    
    // MARK: SUT
    
    private func makeSUT(
        questionId: Question.ID = .make(),
        gemeSettings: GameSettings = .default,
        network: NetworkProtocolMock<ServerCountry> = .init(),
        randomCountryCodeProvider: RandomCountryCodeProviderProtocolMock = .init(),
        store: StorageProtocolMock<Question> = .init()
    ) -> QuestionRepository {
        QuestionRepository(
            questionId: questionId,
            gameSettings: gemeSettings,
            network: network,
            randomCountryCodeProvider: randomCountryCodeProvider,
            storage: store
        )
    }
    
    // MARK: fetchQuestion

    @Test("Country network request succeeds")
    func testThat_WhenServerCountryIsFetched_ThenRequestIsSent() async throws {
        // Given
        let network = NetworkProtocolMock<ServerCountry>()
        network.requestUrlDecoderReturnValue = .make()
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodesNExcludingReturnValue = ["AR", "US", "PR"]
        let sut = self.makeSUT(
            questionId: Question.ID.make(countryCode: "ES"),
            network: network,
            randomCountryCodeProvider: randomCountryCodeProvider
        )
        
        // When
        try await sut.fetchQuestion()
        
        // Then
        #expect(network.requestUrlDecoderCallsCount == 1)
    }
    
    @Test("Country network request fails")
    func testThat_WhenServerCountryIsFetched_AndRequestFails_ThenThrowsError() async {
        // Given
        let network = NetworkProtocolMock<ServerCountry>()
        network.requestUrlDecoderThrowableError = DecodeError.empty
        let sut = self.makeSUT(
            network: network
        )
        
        // When
        // Then
        await #expect(throws: DecodeError.self) {
            try await sut.fetchQuestion()
        }
    }
    
    @Test("Question is created and stored")
    func testThat_WhenQuestionIsFetched_ThenStoredQuestionIsExpected() async throws {
        // Given
        let questionId = Question.ID(gameStamp: Date(timeIntervalSince1970: 0), countryCode: "ES")
        let expectedStoredURL = URL(string: "https://mainfacts.com/media/images/coats_of_arms/es.png")!
        let gameSettings = GameSettings.make(numPossibleChoices: 4)
        let network = NetworkProtocolMock<ServerCountry>()
        network.requestUrlDecoderReturnValue = .make(coatOfArmsURL: expectedStoredURL)
        let randomCountryCodeProvider = RandomCountryCodeProviderProtocolMock()
        randomCountryCodeProvider.generateCodesNExcludingReturnValue = ["AR", "US", "PR"]
        let store = StorageProtocolMock<Question>()
        let sut = self.makeSUT(
            questionId: questionId,
            gemeSettings: gameSettings,
            network: network,
            randomCountryCodeProvider: randomCountryCodeProvider,
            store: store
        )
        
        // When
        try await sut.fetchQuestion()
        
        // Then
        #expect(store.addCallsCount == 1)
        let storedQuestion = try #require(store.addReceivedElement)
        #expect(storedQuestion.id == questionId)
        #expect(storedQuestion.coatOfArmsURL == expectedStoredURL)
        #expect(storedQuestion.otherChoices == ["AR", "US", "PR"])
        #expect(storedQuestion.rightChoicePosition < gameSettings.numPossibleChoices)
    }
    
    // MARK: questionObservable
    
    @Test("Question is observed")
    func testThat_WhenQuestionIsSubscribed_ThenStoredIsObserved() async {
        // Given
        let expectedQuestion = Question.make()
        let store = StorageProtocolMock<Question>()
        store.getSingleElementObservableOfIdReturnValue = Just(expectedQuestion).eraseToAnyPublisher()
        let sut = self.makeSUT(
            store: store
        )
        
        // When
        let question = await sut.questionObservable.values.first { _ in true }
        
        // Then
        #expect(question == expectedQuestion)
    }
}
