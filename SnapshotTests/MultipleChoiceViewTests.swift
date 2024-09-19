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
    private var record = false

    func testMultipleChoiceInteractive() {
        // Given
        let view = MultipleChoiceView(viewModel: MultipleChoiceViewModelDouble_Interative())
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)), record: self.record)
    }
    
    func testMultipleChoiceRightChoice() {
        // Given
        let view = MultipleChoiceView(viewModel: MultipleChoiceViewModelDouble_RightChoice())
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)), record: self.record)
    }
    
    func testMultipleChoiceWrongChoice() {
        // Given
        let view = MultipleChoiceView(viewModel: MultipleChoiceViewModelDouble_WrongChoice())
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)), record: self.record)
    }
}
