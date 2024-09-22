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
    associatedtype ButtonViewModel: ChoiceButtonViewModelProtocol
    var choiceButtons: [ButtonViewModel] { get }
    func viewWillAppear() async
}

/// Represents view containing set of answer buttons
final class MultipleChoiceViewModel<
    OutputScheduler: Scheduler,
    ButtonViewModel: ChoiceButtonViewModelProtocol
>: MultipleChoiceViewModelProtocol {
    
    // MARK: Injected
    
    private let buttonProvider: (CountryCode) -> ButtonViewModel
    private let outputScheduler: OutputScheduler
    private let repository: any MultipleChoiceRepositoryProtocol
    
    // MARK: PossibleAnswersRepositoryProtocol

    @Published var choiceButtons: [ButtonViewModel] = []
    
    // MARK: Observables
    
    private var answersObservable: some Publisher<[ButtonViewModel], Never> {
        self.repository.multipleChoiceObservable
            .map { [self] choices in
                guard let choices else { return [] }
                return choices.allChoices.map { [buttonProvider] in buttonProvider($0) }
            }
    }
    
    // MARK: Lifecycle
    
    init(
        buttonProvider: @escaping (CountryCode) -> ButtonViewModel,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        repository: any MultipleChoiceRepositoryProtocol
    ) {
        self.buttonProvider = buttonProvider
        self.outputScheduler = outputScheduler
        self.repository = repository
        
        self.answersObservable
            .receive(on: outputScheduler)
            .assign(to: &self.$choiceButtons)
    }
    
    // MARK: PossibleAnswersViewModelProtocol
    
    func viewWillAppear() async {
        await self.repository.fetchAnswers()
    }
}

#if DEBUG
extension MultipleChoiceViewModel: CustomDebugStringConvertible  {
    var debugDescription: String {
        "MultipleChoiceViewModel"
    }
}
#endif
