//
//  GameView.swift
//  CoatOfArms
//
//  Created on 2/9/24.
//

import SwiftUI

struct GameView<
    ViewModel: GameViewModelProtocol
>: View {
    
    // MARK: Injected

    @ObservedObject private var viewModel: ViewModel
    private let style: GameViewStyle
    private let restartAction: () -> Void
    
    // MARK: View

    var body: some View {
        Group {
            switch self.viewModel.status {
            case .idle:
                EmptyView()

            case .playing(let question, let remainingLives):
                VStack {
                        QuestionView(
                            viewModel: question,
                            style: self.style.question
                        )
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: self.style.height
                        )
                    
                    RemainingLivesView(
                        viewModel: remainingLives
                    )
                }

            case .gameOver(let score):
                GameOverView(
                    score: score,
                    style: self.style.gameOver,
                    action: self.restartAction
                )
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel,
        style: GameViewStyle,
        restartAction: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.style = style
        self.restartAction = restartAction
    }
}

struct GameViewStyle {
    let height: CGFloat
    let gameOver: GameOverViewStyle
    let question: QuestionViewStyle
}
