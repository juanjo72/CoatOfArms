//
//  UserChoice.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 17/8/24.
//

import Foundation

/// User's pick
struct UserChoice: Identifiable, Equatable {
    let id: CountryCode
    let pickedCountryCode: CountryCode
}
