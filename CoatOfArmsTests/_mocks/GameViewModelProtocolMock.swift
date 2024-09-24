//
//  GameViewModelProtocolMock.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

@testable import CoatOfArms
import Combine

final class GameViewModelProtocolMock: GameViewModelProtocol {
    typealias QuestionViewModel = QuestionViewModelProtocolMock
    typealias RemainingLives = RemainingLivesViewModelProtocolMock
    typealias Router = GameRouterProtocolMock
    
   // MARK: - gameStamp

    var gameStamp: GameStamp {
        get { underlyingGameStamp }
        set(value) { underlyingGameStamp = value }
    }
    private var underlyingGameStamp: GameStamp!
    
   // MARK: - status

    var status: GameStatus<QuestionViewModel, RemainingLives> {
        get { underlyingStatus }
        set(value) { underlyingStatus = value }
    }
    private var underlyingStatus: GameStatus<QuestionViewModel, RemainingLives>!
    
   // MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        viewWillAppearCallsCount > 0
    }
    var viewWillAppearClosure: (() -> Void)?

    func viewWillAppear() {
        viewWillAppearCallsCount += 1
        viewWillAppearClosure?()
    }
}
