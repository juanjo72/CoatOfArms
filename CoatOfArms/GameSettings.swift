//
//  GameSettings.swift
//  CoatOfArms
//
//  Created on 17/8/24.
//

import Foundation

/// Game's global settings
struct GameSettings {
    let numPossibleChoices: Int
    let resultTime: Duration
    let maxWrongAnswers: Int
}

extension GameSettings {
    static var `default`: Self {
        GameSettings(
            numPossibleChoices: 4,
            resultTime: .seconds(1),
            maxWrongAnswers: 3
        )
    }
}
