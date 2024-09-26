//
//  GameStyle+default.swift
//  CoatOfArms
//
//  Created on 1/9/24.
//

extension GameViewStyle {
    static var `default`: Self {
        GameViewStyle(
            gameOver: .default,
            question: .default,
            remainingLives: .default,
            error: .default
        )
    }
}
