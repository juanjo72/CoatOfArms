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

protocol WhichCountryFactoryProtocol {
    associatedtype Quiz: View
    func make(code: CountryCode) -> Quiz
}

struct WhichCountryFactory<
    Router: RouterProtocol
>: WhichCountryFactoryProtocol {
    
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
        let repo = WhichCountryRepository(
            countryCode: code,
            requestSender: sender,
            storage: self.storage
        )
        let multipleChoiceRepo = MultipleChoiceRepository(
            countryCode: code,
            countryCodeProvider: CountryCodeProvider(),
            gameSettings: GameSettings(numPossibleChoices: 4),
            storage: storage
        )
        let multipleChoiceProvider = {
            MultipleChoiceViewModel(
                repository: multipleChoiceRepo,
                router: self.router
            )
        }
        let viewModel = WhichCountryViewModel(
            multipleChoiceProvider: multipleChoiceProvider,
            repository: repo,
            router: self.router
        )
        return WhichCountryView(
            viewModel: viewModel,
            style: .default()
        )
    }
}
