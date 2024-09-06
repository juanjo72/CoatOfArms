//
//  whichCountryRepository.swift
//  CoatOfArms
//
//  Created on 11/8/24.
//

import Combine
import Network
import ReactiveStorage

protocol QuestionRepositoryProtocol {
    var countryObservable: AnyPublisher<ServerCountry?, Never> { get }
    func fetchCountry() async throws
}

/// Question view's data layer
final class QuestionRepository: QuestionRepositoryProtocol {
    
    // MARK: Injected
    
    private let countryCode: CountryCode
    private let requestSender: Network.RequestSenderProtocol
    private let storage: ReactiveStorage.ReactiveStorageProtocol
    
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
        requestSender: Network.RequestSenderProtocol,
        storage: ReactiveStorage.ReactiveStorageProtocol
    ) {
        self.countryCode = countryCode
        self.requestSender = requestSender
        self.storage = storage
    }
    
    // MARK: WhichCountryRepostoryProtocol

    func fetchCountry() async throws {
        let remoteResourceToFetch = Network.RemoteResource<ServerCountry>.make(code: self.countryCode)
        let country = try await self.requestSender.request(resource: remoteResourceToFetch) // actual call
        await self.storage.add(country)
    }
}
