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
    var country: CountryCode { get }
    var loadingState: LoadingState<QuestionViewData<ButtonViewModel>> { get }
    func viewWillAppear() async
}

/// Represents question view, with image and answer buttons
final class QuestionViewModel<
    ButtonViewModel: ChoiceButtonViewModelProtocol,
    OutputScheduler: Scheduler
>: QuestionViewModelProtocol {
    
    // MARK: Injected
    
    private let countryCode: CountryCode
    private let buttonProvider: (CountryCode) -> ButtonViewModel
    private let outputScheduler: OutputScheduler
    private let remoteImagePrefetcher: (URL) -> AnyPublisher<Bool, Never>
    private let repository: any QuestionRepositoryProtocol
    private let router: any GameRouterProtocol

    // MARK: WhichCountryViewModelProtocol
    
    @Published var country: CountryCode
    @Published var loadingState: LoadingState<QuestionViewData<ButtonViewModel>> = .idle
    
    // MARK: Observables
    
    private var prefetchObservable: some Publisher<Bool, Never> {
        self.repository.questionObservable
            .compactMap { $0 }
            .map(\.coatOfArmsURL)
            .flatMap(self.remoteImagePrefetcher)
    }
    
    private var questionObservable: some Publisher<QuestionViewData<ButtonViewModel>?, Never> {
        Publishers.CombineLatest(
            self.repository.questionObservable,
            self.prefetchObservable
        )
        .map { [buttonProvider] question, _ -> QuestionViewData<ButtonViewModel>? in
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
        remoteImagePrefetcher: @escaping (URL) -> AnyPublisher<Bool, Never>,
        repository: any QuestionRepositoryProtocol,
        router: any GameRouterProtocol
    ) {
        self.countryCode = countryCode
        self.buttonProvider = buttonProvider
        self.outputScheduler = outputScheduler
        self.remoteImagePrefetcher = remoteImagePrefetcher
        self.repository = repository
        self.router = router

        self.country = countryCode
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
            print("[ERROR] \(self.country) \(String(describing: error))")
            if error is DecodingError {
                // tries with a new country; possibly coat of arms unavailable
                await self.router.gotNextQuestion()
            }
        }
    }
}

#if DEBUG
extension QuestionViewModel: CustomDebugStringConvertible  {
    var debugDescription: String {
        "QuestionViewModel"
    }
}
#endif
