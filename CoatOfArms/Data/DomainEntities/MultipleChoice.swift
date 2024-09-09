//
//  MultipleChoice.swift
//  CoatOfArms
//
//  Created on 14/8/24.
//

import Foundation

/// Set of possible answers, including the right one
struct MultipleChoice: Identifiable, Equatable {
    struct ID: Hashable {
        let game: GameStamp
        let countryCode: CountryCode
    }
    
    let id: ID
    let otherChoices: [CountryCode]
    let rightChoicePosition: Int
}

extension MultipleChoice {
    var allChoices: [CountryCode] {
        var choices = self.otherChoices
        choices.insert(self.id.countryCode, at: self.rightChoicePosition)
        return choices
    }
}
