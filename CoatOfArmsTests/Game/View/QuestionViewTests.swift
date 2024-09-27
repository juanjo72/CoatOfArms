//
//  QuestionViewTests.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

@testable import CoatOfArms
import Foundation
import SnapshotTesting
import Testing

@Suite("QuestionView", .tags(.viewLayer))
@MainActor
struct QuestionViewTests {
    @Test
    func testQuestionView() {
        let view = QuestionView(
            viewModel: PreviewQuestionViewModel(
                countryCode: "ES",
                imageURL: URL(string: "https://mainfacts.com/media/images/coats_of_arms/es.png")!,
                button: [
                    PreviewChoiceButtonViewModel(countryCode: "FR", label: "France"),
                    PreviewChoiceButtonViewModel(countryCode: "AR", label: "Argentina"),
                    PreviewChoiceButtonViewModel(countryCode: "ES", label: "Spain"),
                    PreviewChoiceButtonViewModel(countryCode: "PT", label: "Portugal"),
                ]
            ),
            style: .default
        ).padding()
        
        withSnapshotTesting(diffTool: .ksdiff) {
            assertSnapshot(
                of: view,
                as: .image(
                    layout: .fixed(width: 402, height: 874)
                ),
                record: false
            )
        }
    }
}
