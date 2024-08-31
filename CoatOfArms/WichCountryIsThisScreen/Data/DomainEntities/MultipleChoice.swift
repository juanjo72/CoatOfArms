//
//  Possible answers.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 14/8/24.
//

import Foundation

/// Set of possible answers, including the right one
struct MultipleChoice: Identifiable, Equatable {
    let id: CountryCode
    let otherChoices: [CountryCode]
    let rightChoicePosition: Int
}

extension MultipleChoice {
    var allChoices: [CountryCode] {
        var choices = self.otherChoices
        choices.insert(self.id, at: self.rightChoicePosition)
        return choices
    }
}
