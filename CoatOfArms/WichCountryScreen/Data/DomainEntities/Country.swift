//
//  Country.swift
//  CoatOfArms
//
//  Created on 11/8/24.
//

import Foundation

/// Ssrver Country with code and Coat-of-arms url
struct Country: Identifiable, Equatable {
    let id: CountryCode
    let coatOfArmsURL: URL
}
