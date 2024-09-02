//
//  GameSettings.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 17/8/24.
//

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
