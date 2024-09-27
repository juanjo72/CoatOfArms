//
//  ChoiceButtonViewModelTests.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

@testable import CoatOfArms
import SnapshotTesting
import Testing

@Suite("Choice Button", .tags(.viewLayer))
@MainActor
struct ChoiceButtonTests {
    @Test
    func testUnselectedButton() {
        let view = ChoiceButton(
            viewModel: PreviewChoiceButtonViewModel(
                tint: .accentColor
            )
        )
        .padding(.horizontal)
        
        withSnapshotTesting(diffTool: .ksdiff) {
            withSnapshotTesting(diffTool: .ksdiff) {
                assertSnapshot(
                    of: view,
                    as: .image(
                        layout: .fixed(width: 300, height: 100)
                    ),
                    record: false
                )
            }
        }
    }
    
    @Test
    func testRightAnswerButton() {
        let view = ChoiceButton(
            viewModel: PreviewChoiceButtonViewModel(
                tint: .green
            )
        )
        .padding(.horizontal)
        
        withSnapshotTesting(diffTool: .ksdiff) {
            assertSnapshot(
                of: view,
                as: .image(
                    layout: .fixed(width: 300, height: 100)
                ),
                record: false
            )
        }
    }
    
    @Test
    func testWrongAnswerButton() {
        let view = ChoiceButton(
            viewModel: PreviewChoiceButtonViewModel(
                tint: .red
            )
        )
            .padding(.horizontal)
        
        withSnapshotTesting(diffTool: .ksdiff) {
            assertSnapshot(
                of: view,
                as: .image(
                    layout: .fixed(width: 300, height: 100)
                ),
                record: false
            )
        }
    }
}
