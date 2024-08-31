//
//  ContentView.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 11/8/24.
//

import ReactiveStorage
import SwiftUI

struct GameView<
    Router: GameRouterProtocol
>: View {
    
    // MARK: Injected

    @ObservedObject private var router: Router
    private let storage: ReactiveStorageProtocol
    
    // MARK: View
    
    var body: some View {
        switch self.router.screen {
        case .question(let countryCode):
            QuestionFactory(
                router: self.router,
                storage: self.storage
            ).make(code: countryCode)
                .padding()
                .id(countryCode)
        case .gameOver(let score):
            GameOverView(score: score) {
                Task {
                    await self.router.reset()
                }
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(
        storage: any ReactiveStorageProtocol,
        router: Router
    ) {
        self.storage = storage
        self.router = router
    }
}
