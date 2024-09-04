//
// RootViewModel.swift
// CoatOfArms
//
// Created on 3/9/24

import Foundation
import Combine

protocol RootViewModelProtocol: ObservableObject {
    associatedtype Game: GameViewModelProtocol
    var game: Game? { get }
    func viewWillAppear()
    func userDidTapRestart()
}

final class RootViewModel<
    OutputScheduler: Scheduler,
    Router: GameViewModelProtocol
>: RootViewModelProtocol {
    private let outputScheduler: OutputScheduler
    private let routerFactory: () -> Router
    
    @Published
    var game: Router?
    
    init(
        outputScheduler: OutputScheduler = DispatchQueue.main,
        gameProvider: @escaping () -> Router
    ) {
        self.outputScheduler = outputScheduler
        self.routerFactory = gameProvider
    }
    
    func viewWillAppear() {
        self.loadAndStartNewRouter()
    }
    
    func userDidTapRestart() {
        self.loadAndStartNewRouter()
    }
    
    private func loadAndStartNewRouter() {
        let newRouter = self.routerFactory()
        self.outputScheduler.schedule {
            self.game = newRouter
        }
        newRouter.start()
    }
}
