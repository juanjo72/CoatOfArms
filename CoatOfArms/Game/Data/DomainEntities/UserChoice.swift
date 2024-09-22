//
//  UserChoice.swift
//  CoatOfArms
//
//  Created on 17/8/24.
//

import Foundation

/// User's answer
struct UserChoice: Identifiable, Equatable {
    let id: Question.ID
    let pickedCountryCode: CountryCode
}

extension UserChoice {
    var isCorrect: Bool {
        self.id.countryCode == self.pickedCountryCode
    }
}
