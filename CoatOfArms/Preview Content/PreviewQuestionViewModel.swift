//
//  PreviewQuestionViewModel.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

import Foundation
import SwiftUI

final class PreviewQuestionViewModel: QuestionViewModelProtocol {
    var countryCode: CountryCode
    var loadingState: LoadingState<QuestionViewData<PreviewChoiceButtonViewModel>>
    
    init(
        countryCode: CountryCode,
        image: Image,
        button: [PreviewChoiceButtonViewModel]
    ) {
        self.countryCode = countryCode
        let question = QuestionViewData(
            image: .image(image),
            buttons: button
        )
        self.loadingState = .loaded(question)
    }
    
    func viewWillAppear() async {}
}
