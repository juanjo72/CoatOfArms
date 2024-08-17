//
//  CountryCode.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 14/8/24.
//

import Foundation

typealias CountryCode = String

extension CountryCode {
    var countryName: String {
        NSLocale().localizedString(forCountryCode: self)
        ?? NSLocale(localeIdentifier: "en").localizedString(forCountryCode: self)
        ?? self
     }
}
