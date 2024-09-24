//
//  PreviewChoiceButtonViewModel.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

import SwiftUI

final class PreviewChoiceButtonViewModel: ChoiceButtonViewModelProtocol {
    let countryCode: CountryCode
    let label: String
    let tint: Color
    
    init(
        countryCode: CountryCode = "ES",
        label: String = "Spain",
        tint: Color = .accentColor
    ) {
        self.countryCode = countryCode
        self.label = label
        self.tint = tint
    }
    
    func viewWillAppear() async {}
    func userDidTap() async {}
}
