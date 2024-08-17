//
//  whichCountryRepository.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 11/8/24.
//

import Combine
import Foundation
import Network
import ReactiveStorage

protocol WhichCountryRepostoryProtocol {
    func countryObservable() -> AnyPublisher<Country?, Never>
    func fetchCountry() async throws
}

final class WhichCountryRepository: WhichCountryRepostoryProtocol {
    
    // MARK: Injected
    
    private let countryCode: CountryCode
    private let requestSender: Network.RequestSenderProtocol
    private let storage: ReactiveStorage.ReactiveStorageProtocol
    
    // MARK: Lifecycle
    
    init(
        countryCode: CountryCode,
        requestSender: Network.RequestSenderProtocol,
        storage: ReactiveStorage.ReactiveStorageProtocol
    ) {
        self.countryCode = countryCode
        self.requestSender = requestSender
        self.storage = storage
    }
    
    // MARK: WhichCountryRepostoryProtocol
    
    func countryObservable() -> AnyPublisher<Country?, Never> {
        self.storage.getSingleElementObservable(of: Country.self, id: self.countryCode)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func fetchCountry() async throws {
        let resource = Network.RemoteResource<Country>.make(code: self.countryCode)
        let country = try await self.requestSender.request(resource: resource)
        await self.storage.add(country)
    }
}
