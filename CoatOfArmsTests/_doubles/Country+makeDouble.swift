//
//  Country+makeDouble.swift
//  CoatOfArmsTests
//
//  Created on 20/8/24.
//

@testable import CoatOfArms
import Foundation

extension Country {
    static func makeDouble(
        id: CountryCode = "es",
        coatOfArmsURL: URL = URL(string: "https://mainfacts.com/media/images/coats_of_arms/es.png")!
    ) -> Country {
        Country(
            id: id,
            coatOfArmsURL: coatOfArmsURL
        )
    }
}
