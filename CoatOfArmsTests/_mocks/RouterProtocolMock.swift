//
//  File.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 21/8/24.
//

@testable import CoatOfArms

final class GameRouterProtocolMock: GameRouterProtocol {
    
   // MARK: - code

    var code: CountryCode {
        get { underlyingCode }
        set(value) { underlyingCode = value }
    }
    private var underlyingCode: CountryCode!
    
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
}
