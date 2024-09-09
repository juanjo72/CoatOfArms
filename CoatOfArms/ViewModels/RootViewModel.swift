//
//  RootViewModel.swift
//  CoatOfArms
//
//  Created on 3/9/24.
//

import Combine
import Foundation

protocol RootViewModelProtocol: ObservableObject {
    associatedtype Game: GameViewModelProtocol
    var game: Game? { get }
    func viewWillAppear() async
    func userDidTapRestart() async
}

final class RootViewModel<
    Game: GameViewModelProtocol,
    OutputScheduler: Scheduler
>: RootViewModelProtocol {
    
    // MARK: Injected

    private let gameProvider: (GameStamp) -> Game
    private let outputScheduler: OutputScheduler
    
    // MARK: RootViewModelProtocol
    
    @Published var game: Game?
    
    // MARK: Lifecycle
    
    init(
        gameProvider: @escaping (GameStamp) -> Game,
        outputScheduler: OutputScheduler = DispatchQueue.main
    ) {
        self.gameProvider = gameProvider
        self.outputScheduler = outputScheduler
    }
    
    // MARK: RootViewModelProtocol
    
    func viewWillAppear() async {
        self.loadAndStartNewGame()
    }
    
    func userDidTapRestart() async {
        self.loadAndStartNewGame()
    }
    
    // MARK: Private
    
    private func loadAndStartNewGame() {
        let newGame = self.gameProvider(.now)
        self.outputScheduler.schedule {
            self.game = newGame
        }
        newGame.start()
    }
}
