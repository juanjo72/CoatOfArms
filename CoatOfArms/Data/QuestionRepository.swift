//
//  whichCountryRepository.swift
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
    var countryObservable: AnyPublisher<ServerCountry?, Never> { get }
    func fetchCountry() async throws
}

/// Question view's data layer
final class QuestionRepository: QuestionRepositoryProtocol {
    
    // MARK: Injected
    
    private let countryCode: CountryCode
    private let network: any NetworkProtocol
    private let storage: any StorageProtocol
    
    // MARK: QuestionRepositoryProtocol
    
    var countryObservable: AnyPublisher<ServerCountry?, Never> {
        self.storage.getSingleElementObservable(
            of: ServerCountry.self,
            id: self.countryCode
        )
        .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        countryCode: CountryCode,
        network: any NetworkProtocol,
        storage: any StorageProtocol
    ) {
        self.countryCode = countryCode
        self.network = network
        self.storage = storage
    }
    
    // MARK: WhichCountryRepostoryProtocol

    func fetchCountry() async throws {
        let url = URL(string: "https://restcountries.com/v3.1/alpha/\(self.countryCode)")!
        let countries: [ServerCountry] = try await self.network.request(url: url)
        guard let country = countries.first else {
            throw DecodeError.empty
        }
        await self.storage.add(country)
    }
}
