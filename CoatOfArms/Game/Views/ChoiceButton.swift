//
//  ChoiceButton.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

import SwiftUI

struct ChoiceButton<
    ViewModel: ChoiceButtonViewModelProtocol
>: View {
    
    @ObservedObject
    private var viewModel: ViewModel
    
    var body: some View {
        Button(
            action: {
                Task {
                    await self.viewModel.userDidTap()
                }
            },
            label: {
                Text(self.viewModel.label)
                    .font(.title2)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(self.viewModel.tint)
        .clipShape(Capsule())
        .task {
            await self.viewModel.viewWillAppear()
        }
    }
    
    init(
        viewModel: ViewModel
    ) {
        self.viewModel = viewModel
    }
}
