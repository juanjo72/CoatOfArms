//
//  ChoiceButtonViewModelProtocolMock.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

@testable import CoatOfArms
import SwiftUI

final class ChoiceButtonViewModelProtocolMock: ChoiceButtonViewModelProtocol {
    
   // MARK: - countryCode

    var countryCode: CountryCode {
        get { underlyingCountryCode }
        set(value) { underlyingCountryCode = value }
    }
    private var underlyingCountryCode: CountryCode!
    
   // MARK: - label

    var label: String {
        get { underlyingLabel }
        set(value) { underlyingLabel = value }
    }
    private var underlyingLabel: String!
    
   // MARK: - tint

    var tint: Color {
        get { underlyingTint }
        set(value) { underlyingTint = value }
    }
    private var underlyingTint: Color!
    
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
    
   // MARK: - userDidTap

    var userDidTapCallsCount = 0
    var userDidTapCalled: Bool {
        userDidTapCallsCount > 0
    }
    var userDidTapClosure: (() -> Void)?

    func userDidTap() {
        userDidTapCallsCount += 1
        userDidTapClosure?()
    }
}
