//
//  Country+makeDouble.swift
//  CoatOfArmsTests
//
//  Created on 20/8/24.
//

@testable import CoatOfArms
import Foundation

extension ServerCountry {
    static func makeDouble(
        id: CountryCode = "ES",
        coatOfArmsURL: URL = URL(string: "https://mainfacts.com/media/images/coats_of_arms/es.png")!
    ) -> ServerCountry {
        ServerCountry(
            id: id,
            coatOfArmsURL: coatOfArmsURL
        )
    }
}
