//
//  Question.swift
//  CoatOfArms
//
//  Created on 30/8/24.
//

import Foundation
import SwiftUI

struct QuestionViewData<
    ButtonViewModel: ChoiceButtonViewModelProtocol
> {
    enum ImageSource {
        case image(Image)
        case url(URL)
    }

    let image: ImageSource
    let buttons: [ButtonViewModel]
}

extension QuestionViewData.ImageSource {
    var url: URL? {
        return switch self {
        case .image:
            nil
        case .url(let url):
            url
        }
    }
}
