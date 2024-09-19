//
//  QuestionView.swift
//  CoatOfArms
//
//  Created on 20/8/24.
//

import Kingfisher
import SwiftUI

struct QuestionView<
    ViewModel: QuestionViewModelProtocol
>: View {
    
    // MARK: Injected
    
    @ObservedObject private var viewModel: ViewModel
    private let style: QuestionViewStyle
    
    @Environment(\.deviceOrientation) private var deviceOrientation

    // MARK: View
    
    var body: some View {
        VStack {
            switch self.viewModel.loadingState {
            case .idle:
                EmptyView()

            case .loading:
                ProgressView()
                
            case .loaded(let question):
                DynamicStack(
                    spacing: self.style.spacing
                ) {
                    if self.deviceOrientation == .portrait || self.deviceOrientation == .portraitUpsideDown || self.deviceOrientation == .unknown {
                        Spacer()
                    }
                    
                    KFImage(question.imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                    
                    MultipleChoiceView(
                        viewModel: question.multipleChoice
                    )
                }
            }
        }
        .task(
            id: self.viewModel.country
        ) {
            await self.viewModel.viewWillAppear()
        }
    }
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel,
        style: QuestionViewStyle
    ) {
        self.viewModel = viewModel
        self.style = style
    }
}

// MARK: Style

struct QuestionViewStyle {
    let spacing: CGFloat

    init(
        spacing: CGFloat
    ) {
        self.spacing = spacing
    }
}

#Preview {
    QuestionView(
        viewModel: QuestionViewModelDouble_Interactive(),
        style: .default
    )
}
