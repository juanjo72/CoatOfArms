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
                    if self.deviceOrientation.isPortrait
                        || self.deviceOrientation == .unknown {
                        Spacer()
                    }
                    
                    KFImage(question.imageURL)
                        .resizable()
                        .frame(
                            minWidth: self.deviceOrientation.isLandscape ? 200 : nil
                        )
                        .frame(
                            minHeight: self.deviceOrientation.isPortrait ? 200 : nil
                        )
                        .aspectRatio(contentMode: .fit)
                        .padding(self.deviceOrientation.isPortrait ? .horizontal : .vertical)
                        .allowsHitTesting(false)
                        .accessibilityLabel(Text("Unknown Coat of Arms"))
                    
                    VStack {
                        ForEach(question.buttons, id: \.countryCode) { button in
                            ChoiceButton(viewModel: button)
                                .task {
                                    await button.viewWillAppear()
                                }
                        }
                    }
                    .layoutPriority(1)
                }
            }
        }
        .task(
            id: self.viewModel.countryCode
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
        viewModel: PreviewQuestionViewModel(
            countryCode: "ES",
            imageURL: URL(string: "https://mainfacts.com/media/images/coats_of_arms/es.png")!,
            button: [
                PreviewChoiceButtonViewModel(countryCode: "FR", label: "France"),
                PreviewChoiceButtonViewModel(countryCode: "ES", label: "Spain"),
                PreviewChoiceButtonViewModel(countryCode: "PT", label: "Portugal"),
            ]
        ),
        style: .default
    )
    .padding()
}
