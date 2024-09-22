//
//  Question.swift
//  CoatOfArms
//
//  Created on 22/9/24.
//

import Foundation

struct Question: Identifiable, Equatable {
    struct ID: Hashable {
        let gameStamp: GameStamp
        let countryCode: CountryCode
    }
    
    let id: ID
    let coatOfArmsURL: URL
    let otherChoices: [CountryCode]
    let rightChoicePosition: Int
}

extension Question {
    var allChoices: [CountryCode] {
        var choices = self.otherChoices
        choices.insert(self.id.countryCode, at: self.rightChoicePosition)
        return choices
    }
}
