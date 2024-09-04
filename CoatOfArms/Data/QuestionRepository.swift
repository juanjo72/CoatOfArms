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
    func countryObservable() -> AnyPublisher<ServerCountry?, Never>
    func fetchCountry() async throws
}

final class QuestionRepository: QuestionRepositoryProtocol {
    
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
    
    func countryObservable() -> AnyPublisher<ServerCountry?, Never> {
        self.storage.getSingleElementObservable(of: ServerCountry.self, id: self.countryCode)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func fetchCountry() async throws {
        let remoteResource = Network.RemoteResource<ServerCountry>.make(code: self.countryCode)
        let country = try await self.requestSender.request(resource: remoteResource)
        await self.storage.add(country)
    }
}
