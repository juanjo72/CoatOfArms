//
//  RemainingLivesViewTests.swift
//  CoatOfArmsTests
//
//  Created on 10/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import XCTest

final class RemainingLivesViewTests: XCTestCase {
    func test() {
        // Given
        let view = RemainingLivesView(
            viewModel: RemainingLivesViewModel_Double(
                numberOfLives: 1,
                totalLives: 3
            )
        )
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)))
    }
}
