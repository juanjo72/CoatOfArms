//
//  ChoiceButtonViewModelFactory.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

import Foundation

struct ChoiceButtonViewModelFactory {
    private let questionId: Question.ID
    private let gameSettings: GameSettings
    private let router: any GameRouterProtocol
    private let store: any StorageProtocol
    
    init(
        questionId: Question.ID,
        gameSettings: GameSettings,
        router: any GameRouterProtocol,
        store: any StorageProtocol
    ) {
        self.questionId = questionId
        self.gameSettings = gameSettings
        self.router = router
        self.store = store
    }

    func make(code: CountryCode) -> some ChoiceButtonViewModelProtocol {
        let countryNameProvider = GetCountryName(
            locale: Locale.current
        )
        let playSound = PlaySound()
        let repository = ChoiceButtonRepository(
            buttonCode: code,
            questionId: self.questionId,
            store: self.store
        )
        return ChoiceButtonViewModel(
            countryCode: code,
            gameSettings: self.gameSettings,
            getCountryName: countryNameProvider,
            playSound: playSound,
            repository: repository,
            router: self.router
        )
    }
}
