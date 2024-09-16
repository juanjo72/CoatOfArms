//
//  MultipleChoiceView.swift
//  CoatOfArms
//
//  Created on 20/8/24.
//

import SwiftUI

struct MultipleChoiceView<
    ViewModel: MultipleChoiceViewModelProtocol
>: View {
    
    // MARK: Injected
    
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: View
    
    var body: some View {
        VStack {
            ForEach(
                self.viewModel.choiceButtons,
                id: \.id
            ) { button in
                Button(
                    action: {
                        Task {
                            await self.viewModel.userDidHit(code: button.id)
                        }
                    },
                    label: {
                        Text(button.label)
                            .frame(maxWidth: .infinity)
                    }
                )
                .buttonStyle(.borderedProminent)
                .tint(button.effect.color)
                .allowsHitTesting(self.viewModel.isEnabled)
                .clipShape(Capsule())
            }
        }
        .task {
            await self.viewModel.viewWillAppear()
        }
    }
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel
    ) {
        self.viewModel = viewModel
    }
}

#Preview {
    MultipleChoiceView(
        viewModel: MultipleChoiceViewModelDouble_Interative()
    )
}

#Preview {
    MultipleChoiceView(
        viewModel: MultipleChoiceViewModelDouble_RightChoice()
    )
}

#Preview {
    MultipleChoiceView(
        viewModel: MultipleChoiceViewModelDouble_WrongChoice()
    )
}
