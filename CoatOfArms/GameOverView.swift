//
//  GameOverView.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 31/8/24.
//

import SwiftUI

struct GameOverView: View {
    private let score: Int
    private let action: () -> Void

    var body: some View {
        VStack(
            spacing: 20
        ) {
            Text("Game over")
                .font(.title)

            Text("Score: \(self.score)")

            Button(
                action: self.action,
                label: {
                    Text("Start again")
                }
            )
            .clipShape(Capsule())
            .buttonStyle(.borderedProminent)
        }
    }
    
    init(
        score: Int,
        action: @escaping () -> Void
    ) {
        self.score = score
        self.action = action
    }
}
