//
// QuestionRepositoryProtocolMock.swift
// CoatOfArmsTests
//
// Created on 6/9/24
//
    
@testable import CoatOfArms
import Combine

final class QuestionRepositoryProtocolMock: QuestionRepositoryProtocol {
    
   // MARK: - countryObservable

    var countryObservable: AnyPublisher<ServerCountry?, Never> {
        get { underlyingCountryObservable }
        set(value) { underlyingCountryObservable = value }
    }
    private var underlyingCountryObservable: AnyPublisher<ServerCountry?, Never>!
    
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
