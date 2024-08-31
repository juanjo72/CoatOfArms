//
//  WhichCountryViewDouble.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import Foundation


final class WhichCountryViewModelDouble_Interactive: QuestionViewModelProtocol {
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

final class WhichCountryViewModelDouble_RightChoice: QuestionViewModelProtocol {
    var loadingState: LoadingState<QuestionViewData<some MultipleChoiceViewModelProtocol>> = {
        .loaded(
            QuestionViewData(
                imageURL: URL(string: "https://mainfacts.com/media/images/coats_of_arms/ar.png")!, 
                multipleChoice: MultipleChoiceViewModelDouble_RightChoice()
            )
        )
    }()
    
    func viewWillAppear() async {}
}

final class WhichCountryViewModelDouble_WrongChoice: QuestionViewModelProtocol {
    var loadingState: LoadingState<QuestionViewData<some MultipleChoiceViewModelProtocol>> = {
        .loaded(
            QuestionViewData(
                imageURL: URL(string: "https://mainfacts.com/media/images/coats_of_arms/ar.png")!,
                multipleChoice: MultipleChoiceViewModelDouble_WrongChoice()
            )
        )
    }()
    
    func viewWillAppear() async {}
}
