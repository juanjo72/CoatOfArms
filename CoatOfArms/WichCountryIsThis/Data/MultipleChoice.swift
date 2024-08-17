//
//  Possible answers.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 14/8/24.
//

import Foundation

struct MultipleChoice: Identifiable, Equatable {
    let id: CountryCode
    let otherChoices: [CountryCode]
    let rightChoicePosition: Int
    
    init(
        id: CountryCode,
        otherChoices: [CountryCode],
        rightChoicePosition: Int
    ) {
        self.id = id
        self.otherChoices = otherChoices
        self.rightChoicePosition = rightChoicePosition
    }
}

extension MultipleChoice {
    var allChoices: [CountryCode] {
        var choices = self.otherChoices
        choices.insert(self.id, at: self.rightChoicePosition)
        return choices
    }
}
