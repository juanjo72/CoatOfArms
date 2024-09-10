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
    associatedtype MultipleChoice: MultipleChoiceViewModelProtocol
    var country: CountryCode { get }
    var loadingState: LoadingState<QuestionViewData<MultipleChoice>> { get }
    func viewWillAppear() async
}

/// Represents question view, with image and answer buttons
final class QuestionViewModel<
    MultipleChoice: MultipleChoiceViewModelProtocol,
    OutputScheduler: Scheduler
>: QuestionViewModelProtocol {
    
    // MARK: Injected
    
    private let countryCode: CountryCode
    private let multipleChoiceProvider: () -> MultipleChoice
    private let outputScheduler: OutputScheduler
    private let remoteImagePrefetcher: (URL) -> AnyPublisher<Bool, Never>
    private let repository: QuestionRepositoryProtocol
    private let nextAction: () async -> Void

    // MARK: WhichCountryViewModelProtocol
    
    @Published var country: CountryCode
    @Published var loadingState: LoadingState<QuestionViewData<MultipleChoice>> = .idle
    
    // MARK: Observables
    
    private var imageURLObservable: some Publisher<URL?, Never> {
        self.repository.countryObservable
            .map(\.?.coatOfArmsURL)
    }
    
    private var prefetchObservable: some Publisher<Bool, Never> {
        self.imageURLObservable
            .compactMap { $0 }
            .flatMap(self.remoteImagePrefetcher)
    }
    
    private var questionObservable: some Publisher<QuestionViewData<MultipleChoice>?, Never> {
        Publishers.CombineLatest(
            self.imageURLObservable,
            self.prefetchObservable
        )
        .map { [multipleChoiceProvider] url, _ -> QuestionViewData<MultipleChoice>? in
            guard let url else { return nil }
            return QuestionViewData(
                imageURL: url,
                multipleChoice: multipleChoiceProvider()
            )
        }
    }
    
    // MARK: Lifecycle
    
    init(
        countryCode: CountryCode,
        multipleChoiceProvider: @escaping () -> MultipleChoice,
        outputScheduler: OutputScheduler = DispatchQueue.main,
        remoteImagePrefetcher: @escaping (URL) -> AnyPublisher<Bool, Never>,
        repository: QuestionRepositoryProtocol,
        nextAction: @escaping () async -> Void
    ) {
        self.countryCode = countryCode
        self.multipleChoiceProvider = multipleChoiceProvider
        self.outputScheduler = outputScheduler
        self.remoteImagePrefetcher = remoteImagePrefetcher
        self.repository = repository
        self.nextAction = nextAction

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
            try await self.repository.fetchCountry()
        } catch {
            print("[ERROR] \(self.country) \(String(describing: error))")
            if error is DecodingError {
                // tries with a new country; possibly coat of arms unavailable
                await self.nextAction()
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
