//
//  MultipleChoiceRepositoryProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 6/9/24.
//

@testable import CoatOfArms
import Combine

final class MultipleChoiceRepositoryProtocolMock: MultipleChoiceRepositoryProtocol {
    
   // MARK: - multipleChoiceObservable

    var multipleChoiceObservable: AnyPublisher<MultipleChoice?, Never> {
        get { underlyingMultipleChoiceObservable }
        set(value) { underlyingMultipleChoiceObservable = value }
    }
    private var underlyingMultipleChoiceObservable: AnyPublisher<MultipleChoice?, Never>!
    
   // MARK: - storedAnswerObservable

    var userChoiceObservable: AnyPublisher<UserChoice?, Never> {
        get { underlyingStoredAnswerObservable }
        set(value) { underlyingStoredAnswerObservable = value }
    }
    private var underlyingStoredAnswerObservable: AnyPublisher<UserChoice?, Never>!
    
   // MARK: - fetchAnswers

    var fetchAnswersCallsCount = 0
    var fetchAnswersCalled: Bool {
        fetchAnswersCallsCount > 0
    }
    var fetchAnswersClosure: (() -> Void)?

    func fetchAnswers() {
        fetchAnswersCallsCount += 1
        fetchAnswersClosure?()
    }
    
   // MARK: - set

    var setAnswerCallsCount = 0
    var setAnswerCalled: Bool {
        setAnswerCallsCount > 0
    }
    var setAnswerReceivedAnswer: CountryCode?
    var setAnswerReceivedInvocations: [CountryCode] = []
    var setAnswerClosure: ((CountryCode) -> Void)?

    func set(answer: CountryCode) {
        setAnswerCallsCount += 1
        setAnswerReceivedAnswer = answer
        setAnswerReceivedInvocations.append(answer)
        setAnswerClosure?(answer)
    }
}
