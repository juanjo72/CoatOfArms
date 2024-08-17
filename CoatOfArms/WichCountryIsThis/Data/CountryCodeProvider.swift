//
//  RandomCountryGenerator.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 14/8/24.
//

import Foundation

protocol CountryCodeProviderProtocol {
    func generate(excluding: [CountryCode]) -> CountryCode
    func generate(n: Int, excluding: [CountryCode]) -> [CountryCode]
}

struct CountryCodeProvider: CountryCodeProviderProtocol {
    func generate(excluding: [CountryCode]) -> CountryCode {
        let allCodes = Set(NSLocale.isoCountryCodes)
        let allButExcluding = allCodes.subtracting(excluding)
        return allButExcluding.first!
    }
    
    func generate(n: Int, excluding: [CountryCode]) -> [CountryCode] {
        let allCodes = Set(NSLocale.isoCountryCodes)
        let allButExcluding = allCodes.subtracting(excluding)
        let slice = Array(allButExcluding)[0..<n]
        return Array(slice)
    }
}
