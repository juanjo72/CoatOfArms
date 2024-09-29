//
//  GameOverViewTests.swift
//  CoatOfArms
//
//  Created on 29/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import Testing

@Suite("Game Over", .tags(.viewLayer))
@MainActor
struct GameOverViewTests {
    @Test
    func testGameOver() {
        let view = GameOverView(
            score: 12,
            style: .default,
            action: {}
        )
        
        withSnapshotTesting(diffTool: .ksdiff) {
            assertSnapshot(
                of: view,
                as: .image(
                    layout: .fixed(width: 300, height: 300)
                ),
                record: false
            )
        }
    }
}
