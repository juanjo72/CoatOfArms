//
//  GameRouter.swift
//  CoatOfArms
//
//  Created on 4/9/24.
//
    
import Combine
import Foundation

protocol GameViewModelProtocol: ObservableObject {
    associatedtype QuestionViewModel: QuestionViewModelProtocol
    associatedtype RemainingLives: RemainingLivesViewModelProtocol
    var gameStamp: GameStamp { get }
    var status: GameStatus<QuestionViewModel, RemainingLives> { get }
    func viewWillAppear() async
}

/// Represents a new game with a new stamp
final class GameViewModel<
    QuestionViewModel: QuestionViewModelProtocol,
    RemainingLives: RemainingLivesViewModelProtocol,
    OutputScheduler: Scheduler,
    Router: GameRouterProtocol
>: GameViewModelProtocol {
    typealias Status = GameStatus<QuestionViewModel, RemainingLives>
    
    // MARK: Injected

    internal let gameStamp: GameStamp
    private let outputScheduler: OutputScheduler
    private let router: Router
    
    // MARK: GameRouterProtocol
    
    @Published var status: Status = .idle
    
    // MARK: Lifecycle
    
    init(
        gameStamp: GameStamp,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        router: Router
    ) where Router.QuestionViewModel == QuestionViewModel, Router.RemainingLives == RemainingLives {
        self.gameStamp = gameStamp
        self.router = router
        self.outputScheduler = outputScheduler
        
        self.router.pathObservable
            .receive(on: self.outputScheduler)
            .assign(to: &self.$status)
    }
    
    // MARK: GameRouterProtocol
    
    func viewWillAppear() async {
        await self.router.gotNextQuestion()
    }
}
