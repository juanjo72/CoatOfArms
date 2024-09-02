//
//  AnswerRow.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 14/8/24.
//

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
        if id == userChoice.id, userChoice.id == userChoice.pickedCountryCode {
            self = .rightChoice
        } else if id == userChoice.pickedCountryCode, userChoice.id != userChoice.pickedCountryCode {
            self = .wrongChoice
        } else {
            self = .none
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
