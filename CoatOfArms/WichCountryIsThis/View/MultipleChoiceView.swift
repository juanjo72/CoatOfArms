//
//  MultipleChoiceView.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import SwiftUI

struct MultipleChoiceView<
    ViewModel: MultipleChoiceViewModelProtocol
>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            ForEach(
                self.viewModel.choiceButtons,
                id: \.id
            ) { button in
                let color: Color = switch(button.effect) {
                case .none:
                        .accentColor
                case .rightChoice:
                        .green
                case .wrongChoice:
                        .red
                }
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
                .tint(color)
                .disabled(!self.viewModel.isEnabled)
                .overlay(
                    (button.effect != .none) ? color.blendMode(.plusDarker) : nil
                )
                .clipShape(Capsule())
                .padding(.horizontal)
            }
        }
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
