//
//  GameOverViewTestss.swift
//  CoatOfArmsTests
//
//  Created on 10/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import XCTest

final class GameOverViewTests: XCTestCase {
    private var record = false

    func testGameOver() {
        // Given
        let view = GameOverView_Previews.previews
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)), record: self.record)
    }
}
