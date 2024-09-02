//
//  MultipleChoiceViewModelProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 20/8/24.
//

@testable import CoatOfArms

final class MultipleChoiceViewModelProtocolMock: MultipleChoiceViewModelProtocol {
    
   // MARK: - isEnabled

    var isEnabled: Bool {
        get { underlyingIsEnabled }
        set(value) { underlyingIsEnabled = value }
    }
    private var underlyingIsEnabled: Bool!
    
   // MARK: - prompt

    var prompt: String {
        get { underlyingPrompt }
        set(value) { underlyingPrompt = value }
    }
    private var underlyingPrompt: String!
    var choiceButtons: [ChoiceButtonViewData] = []
    
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
    
   // MARK: - userDidHit

    var userDidHitCodeCallsCount = 0
    var userDidHitCodeCalled: Bool {
        userDidHitCodeCallsCount > 0
    }
    var userDidHitCodeReceivedCode: CountryCode?
    var userDidHitCodeReceivedInvocations: [CountryCode] = []
    var userDidHitCodeClosure: ((CountryCode) -> Void)?

    func userDidHit(code: CountryCode) {
        userDidHitCodeCallsCount += 1
        userDidHitCodeReceivedCode = code
        userDidHitCodeReceivedInvocations.append(code)
        userDidHitCodeClosure?(code)
    }
}
