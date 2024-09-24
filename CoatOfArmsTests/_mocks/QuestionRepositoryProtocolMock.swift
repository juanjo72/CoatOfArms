//
//  QuestionRepositoryProtocolMock.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

import Combine
@testable import CoatOfArms

final class QuestionRepositoryProtocolMock: QuestionRepositoryProtocol {
    
   // MARK: - questionObservable

    var questionObservable: AnyPublisher<Question?, Never> {
        get { underlyingQuestionObservable }
        set(value) { underlyingQuestionObservable = value }
    }
    private var underlyingQuestionObservable: AnyPublisher<Question?, Never>!
    
   // MARK: - fetchQuestion

    var fetchQuestionThrowableError: Error?
    var fetchQuestionCallsCount = 0
    var fetchQuestionCalled: Bool {
        fetchQuestionCallsCount > 0
    }
    var fetchQuestionClosure: (() throws -> Void)?

    func fetchQuestion() throws {
        if let error = fetchQuestionThrowableError {
            throw error
        }
        fetchQuestionCallsCount += 1
        try fetchQuestionClosure?()
    }
}
