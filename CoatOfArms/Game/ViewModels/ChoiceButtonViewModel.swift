//
//  ChoiceButtonViewModel.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

import Combine
import Foundation
import SwiftUI

protocol ChoiceButtonViewModelProtocol: ObservableObject {
    var countryCode: CountryCode { get }
    var label: String { get }
    var tint: Color { get }
    func viewWillAppear() async
    func userDidTap() async
}

final class ChoiceButtonViewModel<
    OutputScheduler: Scheduler
>: ChoiceButtonViewModelProtocol {
    
    // MARK: Injected

    internal let countryCode: CountryCode
    private let gameSettings: GameSettings
    private let getCountryName: (CountryCode) -> String
    private let outputScheduler: OutputScheduler
    private let playSound: (SoundEffect) async -> Void
    private let repository: any ChoiceButtonRepositoryProtocol
    private let router: any GameRouterProtocol
    
    // MARK: ChoiceViewModelProtocol
    
    @Published var label: String = ""
    @Published var tint: Color = .clear
    
    // MARK: Observables
    
    private var tintObservable: some Publisher<Color, Never> {
        self.repository.userChoiceObservable
            .map { $0.resultColor }
    }
    
    // MARK: Lifecycle
    
    init(
        countryCode: CountryCode,
        gameSettings: GameSettings,
        getCountryName: @escaping (CountryCode) -> String,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        playSound: @escaping (SoundEffect) async -> Void,
        repository: any ChoiceButtonRepositoryProtocol,
        router: any GameRouterProtocol
    ) {
        self.countryCode = countryCode
        self.gameSettings = gameSettings
        self.getCountryName = getCountryName
        self.outputScheduler = outputScheduler
        self.playSound = playSound
        self.repository = repository
        self.router = router
        
        self.tintObservable
            .receive(on: self.outputScheduler)
            .assign(to: &self.$tint)
    }
    
    // MARK: ChoiceButtonViewModelProtocol
    
    func viewWillAppear() async {
        self.outputScheduler.schedule {
            self.label = self.getCountryName(self.countryCode)
        }
    }
    
    func userDidTap() async {
        let choice = await self.repository.markAsChoice()
        
        if choice.isCorrect {
            await self.playSound(.rightAnswer)
        } else {
            await self.playSound(.wrongAnswer)
        }
        
        try? await Task.sleep(for: self.gameSettings.resultTime)
        await self.router.gotNextQuestion()
    }
}
