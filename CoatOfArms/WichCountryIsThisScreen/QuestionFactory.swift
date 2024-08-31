//
//  WhichCountryFactory.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import Foundation
import Network
import ReactiveStorage
import SwiftUI

import Kingfisher

import Combine

protocol QuestionFactoryProtocol {
    associatedtype Question: View
    func make(code: CountryCode) -> Question
}

struct QuestionFactory<
    Router: GameRouterProtocol
>: QuestionFactoryProtocol {
    
    // MARK: Injected
    
    private let router: Router
    private let storage: ReactiveStorageProtocol
    
    // MARK: Lifecycle
    
    init(
        router: Router,
        storage: ReactiveStorageProtocol
    ) {
        self.router = router
        self.storage = storage
    }
    
    // MARK: WhichCountryFactoryProtocol
    
    func make(code: CountryCode) -> some View {
        let sender = Network.RequestSender.shared()
        let repo = CountryRepository(
            countryCode: code,
            requestSender: sender,
            storage: self.storage
        )
        let multipleChoiceRepo = MultipleChoiceRepository(
            countryCode: code,
            countryCodeProvider: CountryCodeProvider(),
            gameSettings: .default,
            storage: storage
        )
        let multipleChoiceProvider = {
            MultipleChoiceViewModel(
                gameSettings: .default,
                repository: multipleChoiceRepo,
                router: self.router
            )
        }
        let remoteImagePrefetcher: (URL) -> AnyPublisher<Bool, Never> = { url in
            Just(url)
                .prefetch()
                .eraseToAnyPublisher()
        }
        let viewModel = QuestionViewModel(
            multipleChoiceProvider: multipleChoiceProvider,
            remoteImagePrefetcher: remoteImagePrefetcher,
            repository: repo,
            router: self.router
        )
        return QuestionView(
            viewModel: viewModel,
            style: .default()
        )
    }
}
