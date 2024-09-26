//
//  ErrorViewTests.swift
//  CoatOfArms
//
//  Created on 25/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import XCTest

final class ErrorViewTests: XCTestCase {
    func testErrorView() {
        let view = ErrorView(
            message: "The Internet conncection appears to be offline.",
            style: .default,
            action: {}
        )
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)), record: false)
    }
}
