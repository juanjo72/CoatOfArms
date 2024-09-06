//
// GameRouter.swift
// CoatOfArms
//
// Created on 4/9/24
    
import Combine
import Foundation
import ReactiveStorage

enum GameStatus<
    QuestionViewModel: QuestionViewModelProtocol,
    RemainingLives: LivesViewModelProtocol
> {
    case idle
    case playing(question: QuestionViewModel, remainingLives: RemainingLives)
    case gameOver(score: Int)
}

protocol GameViewModelProtocol: ObservableObject {
    associatedtype QuestionViewModel: QuestionViewModelProtocol
    associatedtype RemainingLives: LivesViewModelProtocol
    var status: GameStatus<QuestionViewModel, RemainingLives> { get }
    func next() async
    func start()
}

final class GameViewModel<
    QuestionViewModel: QuestionViewModelProtocol,
    RemainingLives: LivesViewModelProtocol,
    OutputScheduler: Scheduler
>: GameViewModelProtocol {
    
    // MARK: Injected

    private let game: GameStamp
    private let gameSettings: GameSettings
    private let outputScheduler: OutputScheduler
    private let questionProvider: (CountryCode) -> QuestionViewModel
    private let randomCountryCodeProvider: any RandomCountryCodeProviderProtocol
    private let remainingLives: RemainingLives
    private let storage: any ReactiveStorageProtocol
    
    // MARK: GameRouterProtocol
    
    @Published var status: GameStatus<QuestionViewModel, RemainingLives> = .idle
    
    // MARK: Lifecycle
    
    init(
        game: GameStamp,
        gameSettings: GameSettings,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        questionProvider: @escaping (CountryCode) -> QuestionViewModel,
        randomCountryCodeProvider: any RandomCountryCodeProviderProtocol,
        remainingLives: RemainingLives,
        storage: any ReactiveStorageProtocol
    ) {
        self.game = game
        self.gameSettings = gameSettings
        self.outputScheduler = outputScheduler
        self.questionProvider = questionProvider
        self.randomCountryCodeProvider = randomCountryCodeProvider
        self.remainingLives = remainingLives
        self.storage = storage
    }
    
    // MARK: GameRouterProtocol
    
    func start() {
        let newCode = self.randomCountryCodeProvider.generateCode(excluding: [])
        let newQuestion = self.questionProvider(newCode)
        self.outputScheduler.schedule {
            self.status = .playing(
                question: newQuestion,
                remainingLives: self.remainingLives
            )
        }
    }
    
    func next() async {
        let allAnswersInCurrentGame = await self.storage.getAllElements(of: UserChoice.self)
            .filter { [self] in $0.id.game == self.game }
        let rightCount = allAnswersInCurrentGame.filter { $0.isCorrect }.count
        let wrongCount = allAnswersInCurrentGame.count - rightCount
        
        if wrongCount < self.gameSettings.maxWrongAnswers {
            let allShownCountriesSoFar = await self.storage.getAllElements(of: UserChoice.self).map { $0.id.countryCode }
            let newCode = self.randomCountryCodeProvider.generateCode(excluding: allShownCountriesSoFar)
            let newQuestion = self.questionProvider(newCode)
            self.outputScheduler.schedule {
                self.status = .playing(
                    question: newQuestion,
                    remainingLives: self.remainingLives
                )
            }
        } else {
            self.outputScheduler.schedule {
                self.status = .gameOver(score: rightCount)
            }
        }
    }
}

#if DEBUG
extension GameViewModel: CustomDebugStringConvertible  {
    var debugDescription: String {
        "GameViewModel"
    }
}
#endif
