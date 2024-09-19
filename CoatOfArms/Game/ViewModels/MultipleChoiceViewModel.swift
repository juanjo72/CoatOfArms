//
//  MultipleChoiceViewModel.swift
//  CoatOfArms
//
//  Created on 14/8/24.
//

import AudioToolbox
import Combine
import Foundation

protocol MultipleChoiceViewModelProtocol: ObservableObject {
    var isEnabled: Bool { get }
    var choiceButtons: [ChoiceButtonViewData] { get }
    func viewWillAppear() async
    func userDidHit(code: CountryCode) async
}

/// Represents view containing set of answer buttons
final class MultipleChoiceViewModel<
    OutputScheduler: Scheduler
>: MultipleChoiceViewModelProtocol {
    
    // MARK: Injected
    
    private let gameSettings: GameSettings
    private let locale: Locale
    private let outputScheduler: OutputScheduler
    private let repository: any MultipleChoiceRepositoryProtocol
    private let router: any GameRouterProtocol
    
    // MARK: PossibleAnswersRepositoryProtocol
    
    @Published var isEnabled: Bool = true
    @Published var choiceButtons: [ChoiceButtonViewData] = []
    
    // MARK: Observables
    
    private var answersObservable: some Publisher<[ChoiceButtonViewData], Never> {
        Publishers.CombineLatest(
            self.repository.multipleChoiceObservable,
            self.repository.userChoiceObservable
        )
        .map { [locale] choices, userAnswer in
            guard let choices else {
                return []
            }
            return choices.allChoices.map { each in
                ChoiceButtonViewData(
                    id: each,
                    label: each.countryName(locale: locale),
                    effect: ChoiceButtonViewData.Effect(
                        id: each,
                        userChoice: userAnswer
                    )
                )
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(
        gameSettings: GameSettings,
        locale: Locale = Locale.autoupdatingCurrent,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        repository: any MultipleChoiceRepositoryProtocol,
        router: any GameRouterProtocol
    ) {
        self.gameSettings = gameSettings
        self.locale = locale
        self.outputScheduler = outputScheduler
        self.repository = repository
        self.router = router
        
        self.answersObservable
            .receive(on: outputScheduler)
            .assign(to: &self.$choiceButtons)
    }
    
    // MARK: PossibleAnswersViewModelProtocol
    
    func viewWillAppear() async {
        await self.repository.fetchAnswers()
    }
    
    func userDidHit(code: CountryCode) async {
        self.outputScheduler.schedule {
            self.isEnabled = false
        }
        await self.repository.set(answer: code)
        try? await Task.sleep(for: self.gameSettings.resultTime)
        await self.router.gotNextQuestion()
    }
}

#if DEBUG
extension MultipleChoiceViewModel: CustomDebugStringConvertible  {
    var debugDescription: String {
        "MultipleChoiceViewModel"
    }
}
#endif
