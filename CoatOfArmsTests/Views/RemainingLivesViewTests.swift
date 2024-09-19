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
    private var record: Bool = false
    func test() {
        // Given
        let view = RemainingLivesView(
            viewModel: RemainingLivesViewModel_Double(
                numberOfLives: 1,
                totalLives: 3
            ),
            style: .default
        )
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)), record: self.record)
    }
}
