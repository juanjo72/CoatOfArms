//
//  ServerCountry.swift
//  CoatOfArms
//
//  Created on 11/8/24.
//

import Foundation

/// Ssrver entity fetched from server
struct ServerCountry: Identifiable, Equatable {
    let id: CountryCode
    let coatOfArmsURL: URL
}
