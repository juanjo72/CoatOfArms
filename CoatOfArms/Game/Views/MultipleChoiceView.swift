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
    
    // MARK: View
    
    var body: some View {
        VStack {
            ForEach(self.viewModel.choiceButtons, id: \.id) { button in
                ChoiceButton(viewModel: button)
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
