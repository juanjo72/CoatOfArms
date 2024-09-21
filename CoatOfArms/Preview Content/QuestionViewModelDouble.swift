//
//  QuestionViewModelDouble.swift
//  CoatOfArms
//
//  Created on 20/8/24.
//

import Foundation

final class QuestionViewModelDouble_Interactive: QuestionViewModelProtocol {
    var country: CountryCode = "AR"
    var loadingState: LoadingState<QuestionViewData<some MultipleChoiceViewModelProtocol>> = {
        .loaded(
            QuestionViewData(
                imageURL: URL(string: "https://mainfacts.com/media/images/coats_of_arms/ar.png")!,
                multipleChoice: MultipleChoiceViewModelDouble_Interative()
            )
        )
    }()
            
    func viewWillAppear() async {}
}
