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
    func countryObservable(code: String) -> AnyPublisher<Country?, Never>
    func fetchCountry(code: String) async throws
}

final class WhichCountryRepository: WhichCountryRepostoryProtocol {
    
    // MARK: Injected
    
    private let requestSender: Network.RequestSenderProtocol
    private let storage: ReactiveStorage.ReactiveStorageProtocol
    
    // MARK: Lifecycle
    
    init(
        requestSender: Network.RequestSenderProtocol,
        storage: ReactiveStorage.ReactiveStorageProtocol
    ) {
        self.requestSender = requestSender
        self.storage = storage
    }
    
    // MARK: WhichCountryRepostoryProtocol
    
    func countryObservable(code: String) -> AnyPublisher<Country?, Never> {
        self.storage.getSingleElementObservable(of: Country.self, id: code)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func fetchCountry(code: String) async throws {
        let resource = Network.RemoteResource<Country>.make(code: code)
        let country = try await self.requestSender.request(resource: resource)
        await self.storage.add(country)
    }
}
