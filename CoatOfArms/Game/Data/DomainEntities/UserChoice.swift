//
//  UserChoice.swift
//  CoatOfArms
//
//  Created on 17/8/24.
//

import Foundation
import SwiftUI

/// User's answer
struct UserChoice: Identifiable, Equatable {
    let id: Question.ID
    let pickedCountryCode: CountryCode
}

extension UserChoice {
    var isCorrect: Bool {
        self.id.countryCode == self.pickedCountryCode
    }
}

extension Optional<UserChoice> {
    var resultColor: Color {
        return switch self {
        case .none:
                .accent
        case .some(let choice):
            choice.isCorrect ? .green : .red
        }
    }
}
