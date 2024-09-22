//
//  Question.swift
//  CoatOfArms
//
//  Created on 30/8/24.
//

import Foundation

struct QuestionViewData<
    ButtonViewModel: ChoiceButtonViewModelProtocol
> {
    let imageURL: URL
    let buttons: [ButtonViewModel]
}
