//
//  MultipleChoiceViewTests.swift
//  CoatOfArmsTests
//
//  Created on 10/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import XCTest

final class MultipleChoiceViewTests: XCTestCase {
    func testInteractive() {
        // Given
        let view = MultipleChoiceView(viewModel: MultipleChoiceViewModelDouble_Interative())
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)))
    }
    
    func testRightChoice() {
        // Given
        let view = MultipleChoiceView(viewModel: MultipleChoiceViewModelDouble_RightChoice())
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)))
    }
    
    func testWrongChoice() {
        // Given
        let view = MultipleChoiceView(viewModel: MultipleChoiceViewModelDouble_WrongChoice())
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)))
    }
}
