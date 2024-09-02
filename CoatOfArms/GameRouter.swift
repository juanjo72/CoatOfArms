//
//  Router.swift
//  CoatOfArms
//
//  Created on 20/8/24.
//

import Combine
import Foundation
import ReactiveStorage

enum GameScreen: Equatable {
    case question(code: CountryCode)
    case gameOver(score: Int)
}

protocol GameRouterProtocol: ObservableObject {
    var screen: GameScreen { get }
    func next() async
    func reset() async
}

/// Component used to jump to a different screen
final class GameRouter<
    OutputScheduler: Scheduler
>: GameRouterProtocol {
    
    // MARK: Injected

    private let gameSettings: GameSettings
    private let outputScheduler: OutputScheduler
    private let randomCountryCodeProvider: any RandomCountryCodeProviderProtocol
    private let storage: any ReactiveStorageProtocol
    
    // MARK: RouterProtocol
    
    @Published var screen: GameScreen

    // MARK: Lifecycle
    
    init(
        gameSettings: GameSettings,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        randomCountryCodeProvider: any RandomCountryCodeProviderProtocol,
        storage: any ReactiveStorageProtocol
    ) {
        self.gameSettings = gameSettings
        self.outputScheduler = outputScheduler
        self.randomCountryCodeProvider = randomCountryCodeProvider
        self.storage = storage
        
        self.screen = .question(code: randomCountryCodeProvider.generateCode())
    }
    
    // MARK: RouterProtocol
    
    func next() async {
        let allAnswers = await self.storage.getAllElements(of: UserChoice.self)
        let rightCount = allAnswers.filter { $0.isCorrect }.count
        let wrongCount = allAnswers.count - rightCount
        
        if wrongCount >= self.gameSettings.maxWrongAnswers {
            self.outputScheduler.schedule {
                self.screen = .gameOver(score: rightCount)
            }
        } else {
            let alreadyAnswered = await self.storage.getAllElements(of: UserChoice.self).map(\.id)
            let newCode = self.randomCountryCodeProvider.generateCode(excluding: alreadyAnswered)
            self.outputScheduler.schedule {
                self.screen = .question(code: newCode)
            }
        }
    }
    
    func reset() async {
        await self.storage.removeAllElements(of: UserChoice.self)
        await self.next()
    }
}
