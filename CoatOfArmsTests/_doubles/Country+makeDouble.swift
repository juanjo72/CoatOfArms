//
//  Country+makeDouble.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

@testable import CoatOfArms
import Foundation

extension Country {
    static func makeDouble(
        id: CountryCode = "es",
        coatOfArmsURL: URL = URL(string: "http://")!
    ) -> Country {
        Country(
            id: id,
            coatOfArmsURL: coatOfArmsURL
        )
    }
}
