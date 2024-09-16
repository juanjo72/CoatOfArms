//
//  GameOverView.swift
//  CoatOfArms
//
//  Created on 31/8/24.
//

import SwiftUI

struct GameOverView: View {
    
    // MARK: Injected

    private let score: Int
    private let style: GameOverViewStyle
    private let action: () -> Void
    
    // MARK: View

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
    
    // MARK: Lifecycle
    
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

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 25, style: .default, action: {})
    }
}
