//
//  GameRouterProtocolMock.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

@testable import CoatOfArms
import Combine

final class GameRouterProtocolMock: GameRouterProtocol {
    typealias QuestionViewModel = QuestionViewModelProtocolMock
    typealias RemainingLives = RemainingLivesViewModelProtocolMock
    
   // MARK: - gameStamp

    var gameStamp: GameStamp {
        get { underlyingGameStamp }
        set(value) { underlyingGameStamp = value }
    }
    private var underlyingGameStamp: GameStamp!
    
   // MARK: - pathObservable

    var pathObservable: AnyPublisher<GameStatus<QuestionViewModel, RemainingLives>, Never> {
        get { underlyingPathObservable }
        set(value) { underlyingPathObservable = value }
    }
    private var underlyingPathObservable: AnyPublisher<GameStatus<QuestionViewModel, RemainingLives>, Never>!
    
   // MARK: - start

    var startCallsCount = 0
    var startCalled: Bool {
        startCallsCount > 0
    }
    var startClosure: (() -> Void)?

    func start() {
        startCallsCount += 1
        startClosure?()
    }
    
   // MARK: - gotNextQuestion

    var gotNextQuestionCallsCount = 0
    var gotNextQuestionCalled: Bool {
        gotNextQuestionCallsCount > 0
    }
    var gotNextQuestionClosure: (() -> Void)?

    func gotNextQuestion() {
        gotNextQuestionCallsCount += 1
        gotNextQuestionClosure?()
    }
    
   // MARK: - stop

    var stopCallsCount = 0
    var stopCalled: Bool {
        stopCallsCount > 0
    }
    var stopClosure: (() -> Void)?

    func stop() {
        stopCallsCount += 1
        stopClosure?()
    }
}
