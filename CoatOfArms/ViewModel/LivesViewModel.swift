//
// LivesViewModel.swift
// CoatOfArms
//
// Created on 2/9/24
    

import Combine
import Foundation

protocol LivesViewModelProtocol: ObservableObject {
    var numberOfLives: Int { get }
    var totalLives: Int { get }
}

final class LivesViewModel<
    OutputScheduler: Scheduler
>: LivesViewModelProtocol {
    
    // MARK: Injected
    
    private let gameSettings: GameSettings
    private let outputScheduler: OutputScheduler
    private let repository: RemainingLivesRepositoryProtocol
    
    // MARK: LivesViewModelProtocol
    
    @Published var numberOfLives: Int = 0
    let totalLives: Int
    
    // MARK: Private
    
    private var numberOfLivesObservable: some Publisher<Int, Never> {
        self.repository.wrongAnswers
            .map { $0.count }
            .map { [gameSettings] in gameSettings.maxWrongAnswers - $0 }
    }
    
    // MARK: Lifecycle
    
    init(
        gameSettings: GameSettings,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        repository: RemainingLivesRepositoryProtocol
    ) {
        self.gameSettings = gameSettings
        self.repository = repository
        self.outputScheduler = outputScheduler
        
        self.totalLives = gameSettings.maxWrongAnswers
        self.numberOfLivesObservable
            .receive(on: self.outputScheduler)
            .assign(to: &self.$numberOfLives)
    }
}
