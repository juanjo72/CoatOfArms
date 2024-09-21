//
//  RandomCountryGenerator.swift
//  CoatOfArms
//
//  Created on 14/8/24.
//

import Foundation

protocol RandomCountryCodeProviderProtocol {
    func generateCode(excluding: [CountryCode]) -> CountryCode
    func generateCodes(n: Int, excluding: [CountryCode]) -> [CountryCode]
}

extension RandomCountryCodeProviderProtocol {
    func generateCode(excluding: [CountryCode] = []) -> CountryCode {
        self.generateCode(excluding: [])
    }
}

/// Provides random country codes
struct RandomCountryCodeProvider: RandomCountryCodeProviderProtocol {
    func generateCode(excluding: [CountryCode]) -> CountryCode {
        self.generateCodes(n: 1, excluding: excluding).first!
    }
    
    func generateCodes(n: Int, excluding: [CountryCode]) -> [CountryCode] {
        let allCodes = Set(NSLocale.isoCountryCodes)
        let allButExcluding = allCodes.subtracting(excluding).shuffled()
        return Array(Array(allButExcluding)[0..<n])
    }
}
