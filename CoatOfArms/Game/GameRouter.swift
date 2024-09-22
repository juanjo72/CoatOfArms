//
//  GameRouter.swift
//  CoatOfArms
//
//  Created on 19/9/24.
//

import Combine

protocol GameRouterProtocol {
    associatedtype QuestionViewModel: QuestionViewModelProtocol
    associatedtype RemainingLives: RemainingLivesViewModelProtocol
    var gameStamp: GameStamp { get }
    var pathObservable: AnyPublisher<GameStatus<QuestionViewModel, RemainingLives>, Never> { get }
    func start() async
    func gotNextQuestion() async
    func stop() async
}

/// Component routing in a particular game, specically going to the next question
/// Encloses the logic to see if the game is over
final class GameRouter<
    QuestionViewModel: QuestionViewModelProtocol,
    RemainingLives: RemainingLivesViewModelProtocol
>: GameRouterProtocol {
    typealias Path = GameStatus<QuestionViewModel, RemainingLives>
    
    // MARK: Injected

    internal let gameStamp: GameStamp
    private let gameSettings: GameSettings
    private let questionProvider: (CountryCode) -> QuestionViewModel
    private let randomCodeProvider: any RandomCountryCodeProviderProtocol
    private let remainingLives: RemainingLives
    private let store: any StorageProtocol
    
    // MARK: GameRouterProtocol
    
    var pathObservable: AnyPublisher<Path, Never> {
        self.mutablePathObservable
            .eraseToAnyPublisher()
    }
    
    // MARK: Private
    
    private let mutablePathObservable = CurrentValueSubject<Path, Never>(.idle)
    
    // MARK: Lifecycle
    
    init(
        gameStamp: GameStamp,
        gameSettings: GameSettings,
        questionProvider: @escaping (CountryCode) -> QuestionViewModel,
        randomCodeProvider: any RandomCountryCodeProviderProtocol,
        remainingLives: RemainingLives,
        store: any StorageProtocol
    ) {
        self.gameStamp = gameStamp
        self.gameSettings = gameSettings
        self.questionProvider = questionProvider
        self.randomCodeProvider = randomCodeProvider
        self.remainingLives = remainingLives
        self.store = store
    }
    
    // MARK: GameRouterProtocol
    
    func start() async {
        await self.gotNextQuestion()
    }
    
    func gotNextQuestion() async {
        let allAnswersInCurrentGame = await self.store.getAllElements(of: UserChoice.self).filter { $0.id.gameStamp == self.gameStamp }
        let rightCount = allAnswersInCurrentGame.filter { $0.isCorrect }.count
        let wrongCount = allAnswersInCurrentGame.count - rightCount
        
        if wrongCount < self.gameSettings.maxWrongAnswers {
            await self.showQuestion()
        } else {
            self.mutablePathObservable.value = .gameOver(score: rightCount)
        }
    }
    
    func stop() async {
        self.mutablePathObservable.value = .idle
    }
    
    // MARK: Private
    
    private func showQuestion() async {
        let allShownCountriesSoFar = await self.store.getAllElements(of: UserChoice.self).map { $0.id.countryCode }
        let newCode = self.randomCodeProvider.generateCode(excluding: allShownCountriesSoFar)
        let newQuestion = self.questionProvider(newCode)
        self.mutablePathObservable.value = .playing(
            question: newQuestion,
            remainingLives: self.remainingLives
        )
    }
}
