//
//  GameOverView.swift
//  CoatOfArms
//
//  Created on 31/8/24.
//

import SwiftUI

struct GameOverView: View {
    private let score: Int
    private let style: GameOverViewStyle
    private let action: () -> Void

    var body: some View {
        VStack(
            spacing: self.style.spacing
        ) {
            Text("GAME_OVER")
                .font(.headline)

            Text("SCORE: \(self.score)")
                .font(.subheadline)

            Button(
                action: self.action,
                label: {
                    Text("AGAIN")
                        .padding(.horizontal)
                }
            )
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
    }
    
    init(
        score: Int,
        style: GameOverViewStyle,
        action: @escaping () -> Void
    ) {
        self.score = score
        self.style = style
        self.action = action
    }
}

struct GameOverViewStyle {
    let spacing: CGFloat
}
