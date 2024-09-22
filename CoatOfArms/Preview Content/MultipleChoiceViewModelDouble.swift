//
//  MultipleChoiceViewModelDouble.swift
//  CoatOfArms
//
//  Created on 20/8/24.
//

import SwiftUI

final class MultipleChoiceViewModelDouble_Interative: MultipleChoiceViewModelProtocol {
    var choiceButtons: [ChoiceButtonViewModelDouble] = [
        ChoiceButtonViewModelDouble(),
    ]
    func viewWillAppear() async {}
}

final class MultipleChoiceViewModelDouble_RightChoice: MultipleChoiceViewModelProtocol {
    var choiceButtons: [ChoiceButtonViewModelDouble] = [
        ChoiceButtonViewModelDouble(),
    ]
    func viewWillAppear() async {}
}

final class MultipleChoiceViewModelDouble_WrongChoice: MultipleChoiceViewModelProtocol {
    var choiceButtons: [ChoiceButtonViewModelDouble] = [
        ChoiceButtonViewModelDouble(),
    ]
    func viewWillAppear() async {}
}

final class ChoiceButtonViewModelDouble: ChoiceButtonViewModelProtocol {
    let id: CountryCode = "AR"
    let label: String = "Argentina"
    let tint: Color = .clear
    func viewWillAppear() async {}
    func userDidTap() async {}
}
