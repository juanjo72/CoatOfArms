//
//  ErrorViewTests.swift
//  CoatOfArms
//
//  Created on 25/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import Testing

@Suite("ErrorViewTests", .tags(.viewLayer))
@MainActor
struct ErrorViewTests {
    @Test
    func testErrorView() {
        let view = ErrorView(
            message: "The Internet conncection appears to be offline.",
            style: .default,
            action: {}
        )
        
        assertSnapshot(
            of: view,
            as: .image(
                layout: .device(config: .iPhone8),
                traits: .init(displayScale: 1)
            ),
            record: false
        )
    }
}
