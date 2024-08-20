//
//  File.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

@testable import CoatOfArms
import Combine

final class WhichCountryRepostoryProtocolMock: WhichCountryRepostoryProtocol {
    
   // MARK: - countryObservable

    var countryObservableCallsCount = 0
    var countryObservableCalled: Bool {
        countryObservableCallsCount > 0
    }
    var countryObservableReturnValue: AnyPublisher<Country?, Never>!
    var countryObservableClosure: (() -> AnyPublisher<Country?, Never>)?

    func countryObservable() -> AnyPublisher<Country?, Never> {
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
