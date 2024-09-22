//
//  QuestionRepository.swift
//  CoatOfArms
//
//  Created on 11/8/24.
//

import Combine
import Foundation

enum DecodeError: Error {
    case empty
}

protocol QuestionRepositoryProtocol {
    var questionObservable: AnyPublisher<Question?, Never> { get }
    func fetchQuestion() async throws
}

/// Question view's data layer
final class QuestionRepository: QuestionRepositoryProtocol {
    
    // MARK: Injected
    
    private let questionId: Question.ID
    private let gameSettings: GameSettings
    private let network: any NetworkProtocol
    private let randomCountryCodeProvider: any RandomCountryCodeProviderProtocol
    private let storage: any StorageProtocol
    
    // MARK: QuestionRepositoryProtocol
    
    var questionObservable: AnyPublisher<Question?, Never> {
        self.storage.getSingleElementObservable(
            of: Question.self,
            id: self.questionId
        )
        .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        questionId: Question.ID,
        gameSettings: GameSettings,
        network: any NetworkProtocol,
        randomCountryCodeProvider: any RandomCountryCodeProviderProtocol,
        storage: any StorageProtocol
    ) {
        self.questionId = questionId
        self.gameSettings = gameSettings
        self.network = network
        self.randomCountryCodeProvider = randomCountryCodeProvider
        self.storage = storage
    }
    
    // MARK: WhichCountryRepostoryProtocol
    
    func fetchQuestion() async throws {
        let serverCountry = try await self.fetchCountry()
        let otherChoices = self.randomCountryCodeProvider.generateCodes(
            n: self.gameSettings.numPossibleChoices - 1,
            excluding: [self.questionId.countryCode]
        )
        let rightChoicePosition = (0..<self.gameSettings.numPossibleChoices).randomElement()!
        let question = Question(
            id: self.questionId,
            coatOfArmsURL: serverCountry.coatOfArmsURL,
            otherChoices: otherChoices,
            rightChoicePosition: rightChoicePosition
        )
        await self.storage.add(question)
    }
    
    // MARK: Private

    private func fetchCountry() async throws -> ServerCountry {
        let url = URL(string: "https://restcountries.com/v3.1/alpha/\(self.questionId.countryCode)")!
        let country: ServerCountry = try await self.network.request(url: url) { data in
            guard let country = try JSONDecoder().decode([ServerCountry].self, from: data).first else {
                throw DecodeError.empty
            }
            return country
        }
        return country
    }
}
