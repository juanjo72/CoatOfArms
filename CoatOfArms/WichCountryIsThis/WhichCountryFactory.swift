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

struct WhichCountryFactory {
    func make() -> some View {
        let testCode = NSLocale.isoCountryCodes.randomElement()!
        let sender = Network.RequestSender.shared()
        let storage = ReactiveInMemoryStorage()
        let repo = WhichCountryRepository(
            countryCode: testCode,
            requestSender: sender,
            storage: storage
        )
        let multipleChoiceRepo = MultipleChoiceRepository(
            countryCode: testCode,
            countryCodeProvider: CountryCodeProvider(),
            gameSettings: GameSettings(numPossibleChoices: 5),
            storage: storage
        )
        let multipleChoiceViewModel = MultipleChoiceViewModel(
            repository: multipleChoiceRepo
        )
        let viewModel = WhichCountryViewModel(
            multipleChoiceProvider: { multipleChoiceViewModel },
            repository: repo
        )
        return WhichCountryView(
            viewModel: viewModel,
            style: .init(spacing: 40)
        )
    }
}
