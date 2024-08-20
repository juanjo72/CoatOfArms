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
    
    @ObservedObject var viewModel: ViewModel
    private let style: WhichCountryViewStyle

    var body: some View {
        VStack(
            spacing: self.style.spacing
        ) {
            KFImage(self.viewModel.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)

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
    let spacing: CGFloat
    
    init(spacing: CGFloat) {
        self.spacing = spacing
    }
}

#Preview {
    WhichCountryView(
        viewModel: WhichCountryViewModelDouble_Interactive(),
        style: WhichCountryViewStyle(spacing: 30)
    )
}

#Preview {
    WhichCountryView(
        viewModel: WhichCountryViewModelDouble_RightChoice(),
        style: WhichCountryViewStyle(spacing: 30)
    )
}

#Preview {
    WhichCountryView(
        viewModel: WhichCountryViewModelDouble_WrongChoice(),
        style: WhichCountryViewStyle(spacing: 30)
    )
}
