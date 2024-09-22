//
//  RemainingLivesView.swift
//  CoatOfArms
//
//  Created on 2/9/24.
//

import SwiftUI

struct RemainingLivesView<
    ViewModel: RemainingLivesViewModelProtocol
>: View {
    
    // MARK: Injected

    @ObservedObject private var viewModel: ViewModel
    private let style: RemainingLivesViewStyle
    
    // MARK: View
    
    var body: some View {
        HStack {
            ForEach(0..<self.viewModel.totalLives, id:\.self) { i in
                Circle()
                    .stroke(Color.gray)
                    .fill(i < self.viewModel.numberOfLives ? Color.gray : Color.clear)
                    .frame(
                        width: self.style.circleDiameter,
                        height: self.style.circleDiameter
                    )
                    .animation(.easeOut, value: self.viewModel.numberOfLives)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityValue("You have \(self.viewModel.numberOfLives) lives left")
    }
    
    // MARK: Lifecycle
    
    init(
        viewModel: ViewModel,
        style: RemainingLivesViewStyle
    ) {
        self.viewModel = viewModel
        self.style = style
    }
}

struct RemainingLivesViewStyle {
    let circleDiameter: CGFloat
}
