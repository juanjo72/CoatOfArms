//
//  QuestionViewTests.swift
//  CoatOfArmsTests
//
//  Created on 10/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import XCTest

final class QuestionViewTests: XCTestCase {
    func test() {
        // Given
        let view = QuestionView(viewModel: QuestionViewModelDouble_Interactive(), style: .default)
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)))
    }
}
