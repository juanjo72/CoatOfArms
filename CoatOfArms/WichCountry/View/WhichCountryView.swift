//
//  WhichCountryView.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import Kingfisher
import SwiftUI

struct WhichCountryView<
    ViewModel: WhichCountryViewModelProtocol
>: View {
    
    // MARK: Injected
    
    @ObservedObject var viewModel: ViewModel
    private let style: WhichCountryViewStyle

    // MARK: View
    
    var body: some View {
        DynamicStack(
            spacing: self.style.spacing
        ) {
            KFImage(self.viewModel.imageURL)
                .resizable()
                .placeholder { ProgressView() }
                .fade(duration: 0.25)
                .aspectRatio(contentMode: .fit)
                .frame(width: self.style.imageSide, height: self.style.imageSide)

            if let multipleChoice = self.viewModel.multipleChoice {
                MultipleChoiceView(
                    viewModel: multipleChoice
                )
            }
        }
        .padding()
        .task {
            await self.viewModel.viewWillAppear()
        }
    }
    
    init(
        viewModel: ViewModel,
        style: WhichCountryViewStyle
    ) {
        self.viewModel = viewModel
        self.style = style
    }
}

struct WhichCountryViewStyle {
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
    WhichCountryView(
        viewModel: WhichCountryViewModelDouble_Interactive(),
        style: .default()
    )
}

#Preview {
    WhichCountryView(
        viewModel: WhichCountryViewModelDouble_RightChoice(),
        style: .default()
    )
}

#Preview {
    WhichCountryView(
        viewModel: WhichCountryViewModelDouble_WrongChoice(),
        style: .default()
    )
}
