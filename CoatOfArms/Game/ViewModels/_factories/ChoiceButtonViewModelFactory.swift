//
//  ChoiceButtonViewModelFactory.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

import Foundation

struct ChoiceButtonViewModelFactory {
    typealias QuestionId = (gameStamp: GameStamp, countryCode: CountryCode)

    private let questionId: QuestionId
    private let gameSettings: GameSettings
    private let router: any GameRouterProtocol
    private let storage: any StorageProtocol
    
    init(
        questionId: QuestionId,
        gameSettings: GameSettings,
        router: any GameRouterProtocol,
        storage: any StorageProtocol
    ) {
        self.questionId = questionId
        self.gameSettings = gameSettings
        self.router = router
        self.storage = storage
    }

    func make(code: CountryCode) -> some ChoiceButtonViewModelProtocol {
        let countryNameProvider = GetCountryName(
            locale: Locale.current
        )
        let playSound = PlaySound()
        let repository = ChoiceButtonRepository(
            id: code,
            questionId: self.questionId,
            storage: self.storage
        )
        return ChoiceButtonViewModel(
            id: code,
            gameSettings: self.gameSettings,
            getCountryName: countryNameProvider,
            playSound: playSound,
            repository: repository,
            router: self.router
        )
    }
}
