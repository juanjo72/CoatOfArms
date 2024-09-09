//
//  UserChoice+makeDouble.swift
//  CoatOfArmsTests
//
//  Created on 6/9/24.
//

@testable import CoatOfArms
import Foundation

extension UserChoice {
    static func makeDouble(
        game: Date = Date(timeIntervalSince1970: 0),
        countryCode: CountryCode = "ES",
        pickedCountryCode: CountryCode = "IT"
    ) -> Self {
        UserChoice(
            id: ID(game: game, countryCode: countryCode),
            pickedCountryCode: pickedCountryCode
        )
    }
}
