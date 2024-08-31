//
//  RandomCountryGenerator.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 14/8/24.
//

import Foundation

protocol CountryCodeProviderProtocol {
    func generateCode(excluding: [CountryCode]) -> CountryCode
    func generateCodes(n: Int, excluding: [CountryCode]) -> [CountryCode]
}

/// Provides random country codes
struct CountryCodeProvider: CountryCodeProviderProtocol {
    func generateCode(excluding: [CountryCode]) -> CountryCode {
        self.generateCodes(n: 1, excluding: excluding).first!
    }
    
    func generateCodes(n: Int, excluding: [CountryCode]) -> [CountryCode] {
        let allCodes = Set(NSLocale.isoCountryCodes)
        let allButExcluding = allCodes.subtracting(excluding).shuffled()
        let slice = Array(allButExcluding)[0..<n]
        return Array(slice)
    }
}
