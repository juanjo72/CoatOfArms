//
//  UserChoice.swift
//  CoatOfArms
//
//  Created on 17/8/24.
//

import Foundation

/// User's pick
struct UserChoice: Identifiable, Equatable {
    let id: CountryCode
    let gameId: GameStamp
    let pickedCountryCode: CountryCode
}

extension UserChoice {
    var isCorrect: Bool {
        self.id == self.pickedCountryCode
    }
}
