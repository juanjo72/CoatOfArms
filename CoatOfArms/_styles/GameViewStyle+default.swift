//
//  GameStyle+default.swift
//  CoatOfArms
//
//  Created on 1/9/24.
//

extension GameViewStyle {
    static var `default`: Self {
        GameViewStyle(
            height: 500,
            gameOver: .default,
            question: .default,
            remainingLives: .default
        )
    }
}
