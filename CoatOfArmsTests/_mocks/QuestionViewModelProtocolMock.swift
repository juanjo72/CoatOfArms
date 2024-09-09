//
//  QuestionViewModelProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 8/9/24.
//

@testable import CoatOfArms
import Combine

final class QuestionViewModelProtocolMock<
    MultipleChoice: MultipleChoiceViewModelProtocol
>: QuestionViewModelProtocol {
    
   // MARK: - country

    var country: CountryCode {
        get { underlyingCountry }
        set(value) { underlyingCountry = value }
    }
    private var underlyingCountry: CountryCode!
    
   // MARK: - loadingState

    var loadingState: LoadingState<QuestionViewData<MultipleChoice>> {
        get { underlyingLoadingState }
        set(value) { underlyingLoadingState = value }
    }
    private var underlyingLoadingState: LoadingState<QuestionViewData<MultipleChoice>>!
    
   // MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        viewWillAppearCallsCount > 0
    }
    var viewWillAppearClosure: (() -> Void)?

    func viewWillAppear() {
        viewWillAppearCallsCount += 1
        viewWillAppearClosure?()
    }
}
