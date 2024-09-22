//
//  GameSettings+double.swift
//  CoatOfArmsTests
//
//  Created on 8/9/24
//

@testable import CoatOfArms

extension GameSettings {
    static func make(
        numPossibleChoices: Int = 4,
        resultTime: Duration = .seconds(1),
        maxWrongAnwers: Int = 3
    ) -> Self {
        GameSettings(
            numPossibleChoices: numPossibleChoices,
            resultTime: resultTime,
            maxWrongAnswers: maxWrongAnwers
        )
    }
}
