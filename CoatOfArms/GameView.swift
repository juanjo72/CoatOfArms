//
//  ContentView.swift
//  CoatOfArms
//
//  Created on 11/8/24.
//

import ReactiveStorage
import SwiftUI

struct GameView<
    Router: GameRouterProtocol
>: View {
    
    // MARK: Injected

    @ObservedObject private var router: Router
    private let style: GameViewStyle
    private let storage: ReactiveStorageProtocol
    
    // MARK: View
    
    var body: some View {
        switch self.router.screen {
        case .question(let countryCode):
            QuestionFactory(
                router: self.router,
                storage: self.storage,
                style: self.style.question
            ).make(code: countryCode)
                .id(countryCode)
                .background()
        case .gameOver(let score):
            GameOverView(
                score: score,
                style: self.style.gameOver
            ) {
                Task {
                    await self.router.reset()
                }
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(
        storage: any ReactiveStorageProtocol,
        style: GameViewStyle,
        router: Router
    ) {
        self.storage = storage
        self.style = style
        self.router = router
    }
}

struct GameViewStyle {
    let gameOver: GameOverViewStyle
    let question: QuestionViewStyle
}
