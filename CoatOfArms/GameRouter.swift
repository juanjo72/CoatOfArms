//
//  Router.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import Combine
import Foundation
import ReactiveStorage
import SwiftUI

enum GameScreen {
    case question(CountryCode)
    case gameOver(Int)
}

protocol GameRouterProtocol: ObservableObject {
    var screen: GameScreen { get }
    func next() async
    func reset() async
}

/// General game's router
final class GameRouter<
    OutputScheduler: Scheduler
>: GameRouterProtocol {
    
    // MARK: Injected

    private let countryCodeProvider: CountryCodeProviderProtocol
    private let gameSettings: GameSettings
    private let output: OutputScheduler
    private let storage: ReactiveStorageProtocol
    
    // MARK: RouterProtocol
    
    @Published var screen: GameScreen

    // MARK: Lifecycle
    
    init(
        countryCodeProvider: CountryCodeProviderProtocol,
        gameSettings: GameSettings,
        output: OutputScheduler = DispatchQueue.main,
        storage: ReactiveStorageProtocol
    ) {
        self.countryCodeProvider = countryCodeProvider
        self.gameSettings = gameSettings
        self.output = output
        self.storage = storage
        
        let code = countryCodeProvider.generateCode(excluding: [])
        self.screen = .question(code)
    }
    
    // MARK: RouterProtocol
    
    func next() async {
        let allAnswers = await self.storage.getAllElements(of: UserChoice.self)
        let rightAnswered = allAnswers.filter { $0.isCorrect }
        let wrongAnswered = allAnswers.filter { !$0.isCorrect }
        guard wrongAnswered.count < self.gameSettings.maxWrongAnswers else {
            self.output.schedule {
                self.screen = .gameOver(rightAnswered.count)
            }
            return
        }
        let alreadyAnswered = await self.storage.getAllElements(of: UserChoice.self).map(\.id)
        let newCode = self.countryCodeProvider.generateCode(excluding: alreadyAnswered)
        self.output.schedule {
            self.screen = .question(newCode)
        }
    }
    
    func reset() async {
        await self.storage.removeAllElements(of: UserChoice.self)
        await self.next()
    }
}
