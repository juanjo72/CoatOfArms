//
//  AnswerRow.swift
//  CoatOfArms
//
//  Created on 14/8/24.
//

import SwiftUI

/// View Data representing each one of the choices
struct ChoiceButtonViewData: Equatable {
    enum Effect {
        case none
        case rightChoice
        case wrongChoice
    }
    
    let id: CountryCode
    let label: String
    let effect: Effect
}

extension ChoiceButtonViewData.Effect {
    init(
        id: CountryCode,
        userChoice: UserChoice?
    ) {
        guard let userChoice = userChoice else {
            self = .none
            return
        }
        if id == userChoice.id.countryCode, userChoice.id.countryCode == userChoice.pickedCountryCode {
            self = .rightChoice
        } else if id == userChoice.pickedCountryCode, userChoice.id.countryCode != userChoice.pickedCountryCode {
            self = .wrongChoice
        } else {
            self = .none
        }
    }
}

extension ChoiceButtonViewData.Effect {
    var color: Color {
        return switch(self) {
        case .none:
                .accentColor
        case .rightChoice:
                .green
        case .wrongChoice:
                .red
        }
    }
}

#if DEBUG
extension ChoiceButtonViewData: CustomDebugStringConvertible {
    var debugDescription: String {
        self.label
    }
}
#endif
