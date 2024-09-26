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
    
    // MARK: Injected
    
    @ObservedObject
    private var viewModel: ViewModel
    
    // MARK: View
    
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
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel
    ) {
        self.viewModel = viewModel
    }
}

#Preview("Non selected button")  {
    ChoiceButton(
        viewModel: PreviewChoiceButtonViewModel(
            tint: .accentColor
        )
    )
    .padding(.horizontal)
}

#Preview("Long label") {
    ChoiceButton(
        viewModel: PreviewChoiceButtonViewModel(
            label: "A very very very very very very very very very very very very very very very long name",
            tint: .accentColor
        )
    )
    .padding(.horizontal)
}

#Preview("Right answer") {
    ChoiceButton(
        viewModel: PreviewChoiceButtonViewModel(
            tint: .green
        )
    )
    .padding(.horizontal)
}

#Preview("Wrong answer") {
    ChoiceButton(
        viewModel: PreviewChoiceButtonViewModel(
            tint: .red
        )
    )
    .padding(.horizontal)
}
