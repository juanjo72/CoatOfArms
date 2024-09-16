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
                    KFImage(question.imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: self.style.imageSize.width,
                            height: self.style.imageSize.height
                        )

                    MultipleChoiceView(
                        viewModel: question.multipleChoice
                    )
                }
                .padding()
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
    let imageSize: CGSize
    let spacing: CGFloat

    init(
        imageSize: CGSize,
        spacing: CGFloat
    ) {
        self.imageSize = imageSize
        self.spacing = spacing
    }
}

#Preview {
    QuestionView(
        viewModel: QuestionViewModelDouble_Interactive(),
        style: .default
    )
}
