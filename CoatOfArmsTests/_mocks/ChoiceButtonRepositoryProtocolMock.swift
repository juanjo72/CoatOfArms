//
//  ChoiceButtonRepositoryProtocolMock.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

@testable import CoatOfArms
import Combine

final class ChoiceButtonRepositoryProtocolMock: ChoiceButtonRepositoryProtocol {
    
    // MARK: - userChoiceObservable
    
    var userChoiceObservable: AnyPublisher<UserChoice?, Never> {
        get { underlyingUserChoiceObservable }
        set(value) { underlyingUserChoiceObservable = value }
    }
    private var underlyingUserChoiceObservable: AnyPublisher<UserChoice?, Never>!
    
    // MARK: - markAsChoice
    
    var markAsChoiceCallsCount = 0
    var markAsChoiceCalled: Bool {
        markAsChoiceCallsCount > 0
    }
    var markAsChoiceReturnValue: UserChoice!
    var markAsChoiceClosure: (() -> UserChoice)?
    
    func markAsChoice() -> UserChoice {
        markAsChoiceCallsCount += 1
        return markAsChoiceClosure.map({ $0() }) ?? markAsChoiceReturnValue
    }
}
