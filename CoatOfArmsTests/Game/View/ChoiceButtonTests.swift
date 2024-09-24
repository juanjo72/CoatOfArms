//
//  ChoiceButtonViewModelTests.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import XCTest

final class ChoiceButtonTests: XCTestCase {
    func testUnselectedButton() {
        let view = ChoiceButton(
            viewModel: PreviewChoiceButtonViewModel(
                tint: .accentColor
            )
        )
        .padding(.horizontal)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 300, height: 200)), record: false)
    }
    
    func testRightAnswerButton() {
        let view = ChoiceButton(
            viewModel: PreviewChoiceButtonViewModel(
                tint: .green
            )
        )
        .padding(.horizontal)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 300, height: 200)), record: false)
    }
    
    func testWrongAnswerButton() {
        let view = ChoiceButton(
            viewModel: PreviewChoiceButtonViewModel(
                tint: .red
            )
        )
        .padding(.horizontal)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 300, height: 200)), record: false)
    }
}
