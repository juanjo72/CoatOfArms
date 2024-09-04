//
// RootView.swift
// CoatOfArms
//
// Created on 3/9/24
    

import SwiftUI

struct RootView<
    ViewModel: RootViewModelProtocol
>: View {
    
    // MARK: Injected

    @ObservedObject private var viewModel: ViewModel
    private let style: RootStyle
    
    // MARK: View

    var body: some View {
        Group {
            if let game = self.viewModel.game {
                GameView(
                    viewModel: game,
                    style: self.style.game,
                    restartAction: {
                        Task {
                            await self.viewModel.userDidTapRestart()
                        }
                    }
                )
            }
        }
        .task() {
            await self.viewModel.viewWillAppear()
        }
    }
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel,
        style: RootStyle
    ) {
        self.viewModel = viewModel
        self.style = style
    }
}

struct RootStyle {
    let game: GameViewStyle
}
