//
//  MultipleChoice+makeDouble.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 19/8/24.
//

@testable import CoatOfArms

extension MultipleChoice {
    static func makeDouble(
        id: CountryCode = "es",
        otherChoices: [CountryCode] = ["uk", "ar"],
        rightChoicePosition: Int = 0
    ) -> MultipleChoice {
        MultipleChoice(
            id: id,
            otherChoices: otherChoices,
            rightChoicePosition: rightChoicePosition
        )
    }
}
