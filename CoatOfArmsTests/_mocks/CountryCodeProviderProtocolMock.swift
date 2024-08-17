//
//  CountryProviderProtocolMock.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 17/8/24.
//

@testable import CoatOfArms

final class CountryCodeProviderProtocolMock: CountryCodeProviderProtocol {
    
   // MARK: - generate

    var generateExcludingCallsCount = 0
    var generateExcludingCalled: Bool {
        generateExcludingCallsCount > 0
    }
    var generateExcludingReceivedExcluding: [CountryCode]?
    var generateExcludingReceivedInvocations: [[CountryCode]] = []
    var generateExcludingReturnValue: CountryCode!
    var generateExcludingClosure: (([CountryCode]) -> CountryCode)?

    func generate(excluding: [CountryCode]) -> CountryCode {
        generateExcludingCallsCount += 1
        generateExcludingReceivedExcluding = excluding
        generateExcludingReceivedInvocations.append(excluding)
        return generateExcludingClosure.map({ $0(excluding) }) ?? generateExcludingReturnValue
    }
    
   // MARK: - generate

    var generateNExcludingCallsCount = 0
    var generateNExcludingCalled: Bool {
        generateNExcludingCallsCount > 0
    }
    var generateNExcludingReceivedArguments: (n: Int, excluding: [CountryCode])?
    var generateNExcludingReceivedInvocations: [(n: Int, excluding: [CountryCode])] = []
    var generateNExcludingReturnValue: [CountryCode]!
    var generateNExcludingClosure: ((Int, [CountryCode]) -> [CountryCode])?

    func generate(n: Int, excluding: [CountryCode]) -> [CountryCode] {
        generateNExcludingCallsCount += 1
        generateNExcludingReceivedArguments = (n: n, excluding: excluding)
        generateNExcludingReceivedInvocations.append((n: n, excluding: excluding))
        return generateNExcludingClosure.map({ $0(n, excluding) }) ?? generateNExcludingReturnValue
    }
}
