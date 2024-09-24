//
//  PreviewQuestionViewModel.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

import Foundation

final class PreviewQuestionViewModel: QuestionViewModelProtocol {
    var countryCode: CountryCode
    var loadingState: LoadingState<QuestionViewData<PreviewChoiceButtonViewModel>>
    
    init(
        countryCode: CountryCode,
        imageURL: URL,
        button: [PreviewChoiceButtonViewModel]
    ) {
        self.countryCode = countryCode
        let question = QuestionViewData(
            imageURL: imageURL,
            buttons: button
        )
        self.loadingState = .loaded(question)
    }
    
    func viewWillAppear() async {}
}
