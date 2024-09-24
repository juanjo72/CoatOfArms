//
//  QuestionViewModel.swift
//  CoatOfArms
//
//  Created on 13/8/24.
//

import Combine
import Foundation
import Kingfisher

protocol QuestionViewModelProtocol: ObservableObject {
    associatedtype ButtonViewModel: ChoiceButtonViewModelProtocol
    var countryCode: CountryCode { get }
    var loadingState: LoadingState<QuestionViewData<ButtonViewModel>> { get }
    func viewWillAppear() async
}

/// Represents question view, with image and answer buttons
final class QuestionViewModel<
    ButtonViewModel: ChoiceButtonViewModelProtocol,
    OutputScheduler: Scheduler
>: QuestionViewModelProtocol {
    
    // MARK: Injected
    
    internal let countryCode: CountryCode
    private let buttonProvider: (CountryCode) -> ButtonViewModel
    private let outputScheduler: OutputScheduler
    private let repository: any QuestionRepositoryProtocol
    private let router: any GameRouterProtocol

    // MARK: WhichCountryViewModelProtocol

    @Published var loadingState: LoadingState<QuestionViewData<ButtonViewModel>> = .idle
    
    // MARK: Observables
    
    private var questionObservable: some Publisher<QuestionViewData<ButtonViewModel>?, Never> {
        self.repository.questionObservable
            .map { [buttonProvider] question -> QuestionViewData<ButtonViewModel>? in
                guard let question else { return nil }
                return QuestionViewData(
                    imageURL: question.coatOfArmsURL,
                    buttons: question.allChoices.map(buttonProvider)
                )
            }
    }
    
    // MARK: Lifecycle
    
    init(
        countryCode: CountryCode,
        buttonProvider: @escaping (CountryCode) -> ButtonViewModel,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        repository: any QuestionRepositoryProtocol,
        router: any GameRouterProtocol
    ) {
        self.countryCode = countryCode
        self.buttonProvider = buttonProvider
        self.outputScheduler = outputScheduler
        self.repository = repository
        self.router = router

        self.questionObservable
            .map { question in
                return if let question {
                    .loaded(question)
                } else {
                    .idle
                }
            }
            .receive(on: self.outputScheduler)
            .assign(to: &self.$loadingState)
    }
    
    // MARK: WhichCountryViewModelProtocol
    
    func viewWillAppear() async {
        self.outputScheduler.schedule {
            self.loadingState = .loading
        }
        do {
            try await self.repository.fetchQuestion()
        } catch {
            print("[ERROR] \(self.countryCode) \(String(describing: error))")
            if error is DecodingError {
                // tries with a new country; possibly coat of arms unavailable
                await self.router.gotNextQuestion()
            }
        }
    }
}
