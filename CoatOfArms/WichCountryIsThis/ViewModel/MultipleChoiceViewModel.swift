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
    var rows: [AnswerRow] { get }
    func viewWillAppear() async
    func userDidHit(code: CountryCode) async
}

final class MultipleChoiceViewModel: MultipleChoiceViewModelProtocol {
    
    // MARK: Injected
    
    private let repository: MultipleChoiceRepositoryProtocol
    
    // MARK: PossibleAnswersRepositoryProtocol
    
    @Published var isEnabled: Bool = false
    let prompt: String = "Pick one:"
    @Published var rows: [AnswerRow] = []
    
    // MARK: Observables
    
    private var answersObservable: some Publisher<[AnswerRow], Never> {
        Publishers.CombineLatest(
            self.repository.multipleChoiceObservable(),
            self.repository.storedAnswerObservable()
        )
            .map { answers, userAnswer in
                guard let answers else { return [] }
                let isAnsweredCorrectly: Bool? = {
                    guard let userAnswer else {
                        return nil
                    }
                    return userAnswer.pickedCountryCode == answers.id
                }()
                return answers.allChoices.map { each in
                    AnswerRow(
                        id: each,
                        label: each.countryName,
                        isAnsweredCorrectly: isAnsweredCorrectly
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
            .assign(to: &self.$rows)
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
