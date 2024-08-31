//
//  MultipleChoiceViewModelDouble.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import Foundation

final class MultipleChoiceViewModelDouble_Interative: MultipleChoiceViewModelProtocol {
    var isEnabled: Bool = true
    var prompt: String = "Pick one:"
    var choiceButtons: [ChoiceButtonViewData] = [
        ChoiceButtonViewData(id: "ES", label: "Spain", effect: .none),
        ChoiceButtonViewData(id: "AR", label: "Argentina", effect: .none),
        ChoiceButtonViewData(id: "UK", label: "United Kingdom", effect: .none),
    ]
    
    func viewWillAppear() async {}
    func userDidHit(code: CountryCode) async {}
}

final class MultipleChoiceViewModelDouble_RightChoice: MultipleChoiceViewModelProtocol {
    var isEnabled: Bool = false
    var prompt: String = "Pick one:"
    var choiceButtons: [ChoiceButtonViewData] = [
        ChoiceButtonViewData(id: "ES", label: "Spain", effect: .none),
        ChoiceButtonViewData(id: "AR", label: "Argentina", effect: .rightChoice),
        ChoiceButtonViewData(id: "UK", label: "United Kingdom", effect: .none),
    ]
    
    func viewWillAppear() async {}
    func userDidHit(code: CountryCode) async {}
}

final class MultipleChoiceViewModelDouble_WrongChoice: MultipleChoiceViewModelProtocol {
    var isEnabled: Bool = false
    var prompt: String = "Pick one:"
    var choiceButtons: [ChoiceButtonViewData] = [
        ChoiceButtonViewData(id: "ES", label: "Spain", effect: .wrongChoice),
        ChoiceButtonViewData(id: "AR", label: "Argentina", effect: .none),
        ChoiceButtonViewData(id: "UK", label: "United Kingdom", effect: .none),
    ]
    
    func viewWillAppear() async {}
    func userDidHit(code: CountryCode) async {}
}
