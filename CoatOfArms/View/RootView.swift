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
    
    // MARK: View

    var body: some View {
        VStack {
            if let game = viewModel.game {
                GameView(viewModel: game) {
                    self.viewModel.userDidTapRestart()
                }
            }
        }
        .task {
            self.viewModel.viewWillAppear()
        }
    }
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel
    ) {
        self.viewModel = viewModel
    }
}
