//
//  File.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 21/8/24.
//

@testable import CoatOfArms

final class GameRouterProtocolMock: GameRouterProtocol {
    
   // MARK: - screen

    var screen: GameScreen {
        get { underlyingScreen }
        set(value) { underlyingScreen = value }
    }
    private var underlyingScreen: GameScreen!
    
   // MARK: - next

    var nextCallsCount = 0
    var nextCalled: Bool {
        nextCallsCount > 0
    }
    var nextClosure: (() -> Void)?

    func next() {
        nextCallsCount += 1
        nextClosure?()
    }
    
   // MARK: - reset

    var resetCallsCount = 0
    var resetCalled: Bool {
        resetCallsCount > 0
    }
    var resetClosure: (() -> Void)?

    func reset() {
        resetCallsCount += 1
        resetClosure?()
    }
}
