//
//  GetCountryName.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

import Foundation
import Mockable

@Mockable
protocol GetCountryNameProtocol {
    func getName(for country: CountryCode) -> String
}

struct GetCountryName: GetCountryNameProtocol {
    private let locale: Locale
    
    init(locale: Locale) {
        self.locale = locale
    }
    
    func getName(for country: CountryCode) -> String {
        locale.localizedString(forRegionCode: country)
        ?? Locale(identifier: "en_US").localizedString(forRegionCode: country)
        ?? country
    }
}
