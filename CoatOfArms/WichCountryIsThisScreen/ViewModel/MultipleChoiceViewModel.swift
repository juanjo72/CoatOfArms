//
//  PossibleAnswersViewModel.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 14/8/24.
//

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
    OutputScheduler: Scheduler,
    Router: GameRouterProtocol
>: MultipleChoiceViewModelProtocol {
    
    // MARK: Injected
    
    private let gameSettings: GameSettings
    private let repository: MultipleChoiceRepositoryProtocol
    private let outputScheduler: OutputScheduler
    private let router: Router
    
    // MARK: PossibleAnswersRepositoryProtocol
    
    @Published var isEnabled: Bool = false
    @Published var choiceButtons: [ChoiceButtonViewData] = []
    
    // MARK: Observables
    
    private var answersObservable: some Publisher<[ChoiceButtonViewData], Never> {
        Publishers.CombineLatest(
            self.repository.multipleChoiceObservable(),
            self.repository.storedAnswerObservable()
        )
            .map { choices, userAnswer in
                guard let choices else { return [] }
                return choices.allChoices.map { each in
                    ChoiceButtonViewData(
                        id: each,
                        label: each.countryName,
                        effect: ChoiceButtonViewData.Effect(id: each, userChoice: userAnswer)
                    )
                }
            }
    }
    
    // MARK: Lifecycle
    
    init(
        gameSettings: GameSettings,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        repository: MultipleChoiceRepositoryProtocol,
        router: Router
    ) {
        self.gameSettings = gameSettings
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
        self.outputScheduler.schedule {
            self.isEnabled = true
        }
    }
    
    func userDidHit(code: CountryCode) async {
        self.outputScheduler.schedule {
            self.isEnabled = false
        }
        await self.repository.set(answer: code)
        try? await Task.sleep(for: self.gameSettings.resultTime)
        await self.router.next()
    }
}

#if DEBUG
extension MultipleChoiceViewModel: CustomDebugStringConvertible  {
    var debugDescription: String {
        "MultipleChoiceViewModel"
    }
}
#endif
