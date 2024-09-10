//
//  CountryCode.swift
//  CoatOfArms
//
//  Created on 14/8/24.
//

import Foundation

/// Country code, e. g. ES, PT
typealias CountryCode = String

extension CountryCode {
    func countryName(locale: Locale = Locale.autoupdatingCurrent) -> String {
        locale.localizedString(forRegionCode: self)
        ?? Locale(identifier: "en_US").localizedString(forRegionCode: self)
        ?? self
     }
}
