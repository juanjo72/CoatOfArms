//
// GameView.swift
// CoatOfArms
//
// Created on 2/9/24
    

import SwiftUI

struct GameView<
    ViewModel: GameViewModelProtocol
>: View {
    
    // MARK: Injected

    @ObservedObject private var viewModel: ViewModel
    private var restartAction: () -> Void
    
    // MARK: View

    var body: some View {
        VStack {
            switch self.viewModel.status {
            case .idle:
                EmptyView()
            case .playing(let question, let remainingLives):
                VStack {
                    QuestionView(
                        viewModel: question,
                        style: .default
                    )
                    
                    RemainingLivesView(
                        viewModel: remainingLives
                    )
                }
            case .gameOver(let score):
                GameOverView(score: score, style: .default, action: self.restartAction)
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel,
        restartAction: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.restartAction = restartAction
    }
}
