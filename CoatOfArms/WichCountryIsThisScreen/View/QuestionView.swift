//
//  WhichCountryView.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
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
                                width: self.style.imageSide,
                                alignment: .bottom
                            )
                            .frame(maxHeight: self.style.imageSide)
                        
                        MultipleChoiceView(
                            viewModel: question.multipleChoice
                        )
                    }
                    .padding()
                }
        }
        .task {
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
    let imageSide: CGFloat
    let spacing: CGFloat

    init(
        imageSide: CGFloat,
        spacing: CGFloat
    ) {
        self.imageSide = imageSide
        self.spacing = spacing
    }
}

#Preview {
    QuestionView(
        viewModel: WhichCountryViewModelDouble_Interactive(),
        style: .default()
    )
}

#Preview {
    QuestionView(
        viewModel: WhichCountryViewModelDouble_RightChoice(),
        style: .default()
    )
}

#Preview {
    QuestionView(
        viewModel: WhichCountryViewModelDouble_WrongChoice(),
        style: .default()
    )
}
