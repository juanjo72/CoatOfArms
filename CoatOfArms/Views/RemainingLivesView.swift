//
// LivesView.swift
// CoatOfArms
//
// Created on 2/9/24
    

import SwiftUI

struct RemainingLivesView<
    ViewModel: LivesViewModelProtocol
>: View {
    
    // MARK: Injected

    @ObservedObject private var viewModel: ViewModel
    
    // MARK: View
    
    var body: some View {
        HStack {
            ForEach(0..<self.viewModel.totalLives, id:\.self) { i in
                Circle()
                    .stroke(Color.gray)
                    .fill(i < self.viewModel.numberOfLives ? Color.gray : Color.clear)
                    .frame(width: 10, height: 10)
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel
    ) {
        self.viewModel = viewModel
    }
}
