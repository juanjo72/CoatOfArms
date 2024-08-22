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
        Locale.autoupdatingCurrent.localizedString(forRegionCode: self)
        ?? Locale(identifier: "en_EN").localizedString(forRegionCode: self)
        ?? self
     }
}
