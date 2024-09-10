//
//  Question.swift
//  CoatOfArms
//
//  Created on 30/8/24.
//

import Foundation

struct QuestionViewData<
    MultipleChoice: MultipleChoiceViewModelProtocol
> {
    let imageURL: URL
    let multipleChoice: MultipleChoice
    
    init(
        imageURL: URL,
        multipleChoice: MultipleChoice
    ) {
        self.imageURL = imageURL
        self.multipleChoice = multipleChoice
    }
}

#if DEBUG
extension QuestionViewData: CustomDebugStringConvertible {
    var debugDescription: String {
        "Question for \(self.imageURL.lastPathComponent)"
    }
}
#endif
