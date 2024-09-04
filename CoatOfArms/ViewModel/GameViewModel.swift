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
    
    private var cancellable: [AnyCancellable] = []
    
    // MARK: Lifecycle
    
    deinit {
        print("DEINIT \(String(describing: self))")
    }
    
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
        
         self.$status
            .print("[STATUS]")
            .sink { _ in }
            .store(in: &cancellable)
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
        let allAnswers = await self.storage.getAllElements(of: UserChoice.self).filter { [self] in $0.game == self.game }
        let rightCount = allAnswers.filter { $0.isCorrect }.count
        let wrongCount = allAnswers.count - rightCount
        
        if wrongCount < self.gameSettings.maxWrongAnswers {
            let alreadyAnswered = allAnswers.map { $0.id }
            let newCode = self.randomCountryCodeProvider.generateCode(excluding: alreadyAnswered)
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
