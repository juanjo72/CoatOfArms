//
//  QuestionViewModelProtocolMock.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

@testable import CoatOfArms

final class QuestionViewModelProtocolMock: QuestionViewModelProtocol {
    typealias ButtonViewModel = ChoiceButtonViewModelProtocolMock
    
   // MARK: - country

    var countryCode: CountryCode {
        get { underlyingCountryCode }
        set(value) { underlyingCountryCode = value }
    }
    private var underlyingCountryCode: CountryCode!
    
   // MARK: - loadingState

    var loadingState: LoadingState<QuestionViewData<ButtonViewModel>> {
        get { underlyingLoadingState }
        set(value) { underlyingLoadingState = value }
    }
    private var underlyingLoadingState: LoadingState<QuestionViewData<ButtonViewModel>>!
    
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
