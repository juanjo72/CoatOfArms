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
    private let router: Router
    private let scheduler: OutputScheduler
    
    // MARK: GameRouterProtocol
    
    @Published var status: Status = .idle
    
    // MARK: Lifecycle
    
    init(
        gameStamp: GameStamp,
        router: Router,
        scheduler: OutputScheduler = DispatchQueue.main
    ) where Router.QuestionViewModel == QuestionViewModel, Router.RemainingLives == RemainingLives {
        self.gameStamp = gameStamp
        self.router = router
        self.scheduler = scheduler
        
        self.router.pathObservable
            .receive(on: self.scheduler)
            .assign(to: &self.$status)
    }
    
    // MARK: GameRouterProtocol
    
    func viewWillAppear() async {
        await self.router.gotNextQuestion()
    }
}

#if DEBUG
extension GameViewModel: CustomDebugStringConvertible  {
    var debugDescription: String {
        "GameViewModel"
    }
}
#endif
