//
//  UserChoice.swift
//  CoatOfArms
//
//  Created on 17/8/24.
//

import Foundation

/// User's answer
struct UserChoice: Identifiable, Equatable {
    let id: CountryCode
    let game: GameStamp
    let pickedCountryCode: CountryCode
}

extension UserChoice {
    var isCorrect: Bool {
        self.id == self.pickedCountryCode
    }
}
