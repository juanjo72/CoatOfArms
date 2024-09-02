//
//  MultipleChoiceRepositoryProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 17/8/24.
//

@testable import CoatOfArms
import Combine
@testable import ReactiveStorage

final class MultipleChoiceRepositoryProtocolMock: MultipleChoiceRepositoryProtocol {
    
   // MARK: - multipleChoiceObservable

    var multipleChoiceObservableCallsCount = 0
    var multipleChoiceObservableCalled: Bool {
        multipleChoiceObservableCallsCount > 0
    }
    var multipleChoiceObservableReturnValue: AnyPublisher<MultipleChoice?, Never>!
    var multipleChoiceObservableClosure: (() -> AnyPublisher<MultipleChoice?, Never>)?

    func multipleChoiceObservable() -> AnyPublisher<MultipleChoice?, Never> {
        multipleChoiceObservableCallsCount += 1
        return multipleChoiceObservableClosure.map({ $0() }) ?? multipleChoiceObservableReturnValue
    }
    
   // MARK: - storedAnswerObservable

    var storedAnswerObservableCallsCount = 0
    var storedAnswerObservableCalled: Bool {
        storedAnswerObservableCallsCount > 0
    }
    var storedAnswerObservableReturnValue: AnyPublisher<UserChoice?, Never>!
    var storedAnswerObservableClosure: (() -> AnyPublisher<UserChoice?, Never>)?

    func storedAnswerObservable() -> AnyPublisher<UserChoice?, Never> {
        storedAnswerObservableCallsCount += 1
        return storedAnswerObservableClosure.map({ $0() }) ?? storedAnswerObservableReturnValue
    }
    
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
