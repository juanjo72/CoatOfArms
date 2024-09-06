//
//  MultipleChoice+makeDouble.swift
//  CoatOfArmsTests
//
//  Created on 19/8/24.
//

@testable import CoatOfArms
import Foundation

extension MultipleChoice {
    static func makeDouble(
        game: GameStamp = Date(timeIntervalSince1970: 0),
        countryCode: CountryCode = "ES",
        otherChoices: [CountryCode] = ["IT", "AR", "US"],
        rightChoicePosition: Int = 0
    ) -> MultipleChoice {
        MultipleChoice(
            id: ID(game: game, countryCode: countryCode),
            otherChoices: otherChoices,
            rightChoicePosition: rightChoicePosition
        )
    }
}
