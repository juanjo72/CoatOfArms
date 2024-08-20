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

final class MultipleChoiceViewModel<
    Downstream: Scheduler
>: MultipleChoiceViewModelProtocol {
    
    // MARK: Injected
    
    private let repository: MultipleChoiceRepositoryProtocol
    private let downstream: Downstream
    
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
        repository: MultipleChoiceRepositoryProtocol,
        downstream: Downstream = DispatchQueue.main
    ) {
        self.repository = repository
        self.downstream = downstream
        
        self.answersObservable
            .receive(on: downstream)
            .assign(to: &self.$choiceButtons)
    }
    
    // MARK: PossibleAnswersViewModelProtocol
    
    func viewWillAppear() async {
        await self.repository.fetchAnswers()
        self.downstream.schedule {
            self.isEnabled = true
        }
    }
    
    func userDidHit(code: CountryCode) async {
        self.downstream.schedule {
            self.isEnabled = false
        }
        await self.repository.set(answer: code)
    }
}
