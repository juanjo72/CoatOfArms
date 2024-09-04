//
//  GameRouterProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 20/8/24.
//

@testable import CoatOfArms
import Combine

final class WhichCountryRepostoryProtocolMock: QuestionRepositoryProtocol {
    
   // MARK: - countryObservable

    var countryObservableCallsCount = 0
    var countryObservableCalled: Bool {
        countryObservableCallsCount > 0
    }
    var countryObservableReturnValue: AnyPublisher<ServerCountry?, Never>!
    var countryObservableClosure: (() -> AnyPublisher<ServerCountry?, Never>)?

    func countryObservable() -> AnyPublisher<ServerCountry?, Never> {
        countryObservableCallsCount += 1
        return countryObservableClosure.map({ $0() }) ?? countryObservableReturnValue
    }
    
   // MARK: - fetchCountry

    var fetchCountryThrowableError: Error?
    var fetchCountryCallsCount = 0
    var fetchCountryCalled: Bool {
        fetchCountryCallsCount > 0
    }
    var fetchCountryClosure: (() throws -> Void)?

    func fetchCountry() throws {
        if let error = fetchCountryThrowableError {
            throw error
        }
        fetchCountryCallsCount += 1
        try fetchCountryClosure?()
    }
}
