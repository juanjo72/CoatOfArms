//
//  GetCountryName.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

import Foundation

struct GetCountryName {
    private let locale: Locale
    
    init(
        locale: Locale = Locale.current
    ) {
        self.locale = locale
    }
    
    func callAsFunction(for country: CountryCode) -> String {
        self.locale.localizedString(forRegionCode: country)
        ?? Locale(identifier: "en_US").localizedString(forRegionCode: country)
        ?? country
    }
}
