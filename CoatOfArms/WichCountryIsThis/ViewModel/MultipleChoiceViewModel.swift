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
    var prompt: String { get }
    var choiceButtons: [ChoiceButtonViewData] { get }
    func viewWillAppear() async
    func userDidHit(code: CountryCode) async
}

final class MultipleChoiceViewModel: MultipleChoiceViewModelProtocol {
    
    // MARK: Injected
    
    private let repository: MultipleChoiceRepositoryProtocol
    
    // MARK: PossibleAnswersRepositoryProtocol
    
    @Published var isEnabled: Bool = false
    let prompt: String = "Pick one:"
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
        repository: MultipleChoiceRepositoryProtocol
    ) {
        self.repository = repository
        
        self.answersObservable
            .assign(to: &self.$choiceButtons)
    }
    
    // MARK: PossibleAnswersViewModelProtocol
    
    func viewWillAppear() async {
        await self.repository.fetchAnswers()
        self.isEnabled = true
    }
    
    func userDidHit(code: CountryCode) async {
        self.isEnabled = false
        await self.repository.set(answer: code)
    }
}
