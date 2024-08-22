//
//  CountryProviderProtocolMock.swift
//  CoatOfArmsTests
//
//  Created by Juanjo García Villaescusa on 17/8/24.
//

@testable import CoatOfArms

final class CountryCodeProviderProtocolMock: CountryCodeProviderProtocol {
    
   // MARK: - generateCode

    var generateCodeExcludingCallsCount = 0
    var generateCodeExcludingCalled: Bool {
        generateCodeExcludingCallsCount > 0
    }
    var generateCodeExcludingReceivedExcluding: [CountryCode]?
    var generateCodeExcludingReceivedInvocations: [[CountryCode]] = []
    var generateCodeExcludingReturnValue: CountryCode!
    var generateCodeExcludingClosure: (([CountryCode]) -> CountryCode)?

    func generateCode(excluding: [CountryCode]) -> CountryCode {
        generateCodeExcludingCallsCount += 1
        generateCodeExcludingReceivedExcluding = excluding
        generateCodeExcludingReceivedInvocations.append(excluding)
        return generateCodeExcludingClosure.map({ $0(excluding) }) ?? generateCodeExcludingReturnValue
    }
    
   // MARK: - generateCodes

    var generateCodesNExcludingCallsCount = 0
    var generateCodesNExcludingCalled: Bool {
        generateCodesNExcludingCallsCount > 0
    }
    var generateCodesNExcludingReceivedArguments: (n: Int, excluding: [CountryCode])?
    var generateCodesNExcludingReceivedInvocations: [(n: Int, excluding: [CountryCode])] = []
    var generateCodesNExcludingReturnValue: [CountryCode]!
    var generateCodesNExcludingClosure: ((Int, [CountryCode]) -> [CountryCode])?

    func generateCodes(n: Int, excluding: [CountryCode]) -> [CountryCode] {
        generateCodesNExcludingCallsCount += 1
        generateCodesNExcludingReceivedArguments = (n: n, excluding: excluding)
        generateCodesNExcludingReceivedInvocations.append((n: n, excluding: excluding))
        return generateCodesNExcludingClosure.map({ $0(n, excluding) }) ?? generateCodesNExcludingReturnValue
    }
}
