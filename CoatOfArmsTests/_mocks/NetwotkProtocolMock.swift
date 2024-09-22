//
//  NetworkProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 9/9/24.
//

@testable import CoatOfArms
import Foundation

final class NetworkProtocolMock<U>: NetworkProtocol {
    
   // MARK: - request<T>

    var requestUrlDecoderThrowableError: Error?
    var requestUrlDecoderCallsCount = 0
    var requestUrlDecoderCalled: Bool {
        requestUrlDecoderCallsCount > 0
    }
    var requestUrlDecoderReceivedArguments: (url: URL, decoder: (Data) throws -> U)?
    var requestUrlDecoderReceivedInvocations: [(url: URL, decoder: (Data) throws -> U)] = []
    var requestUrlDecoderReturnValue: U!
    var requestUrlDecoderClosure: ((URL, @escaping (Data) throws -> U) throws -> U)?

    func request<T>(url: URL, decoder: @escaping (Data) throws -> T) throws -> T {
        if let error = requestUrlDecoderThrowableError {
            throw error
        }
        requestUrlDecoderCallsCount += 1
        let x = (url: url, decoder: decoder) as! (URL, (Data) throws -> U)
        requestUrlDecoderReceivedArguments = x
        requestUrlDecoderReceivedInvocations.append(x)
        return try requestUrlDecoderClosure.map({ try $0(url, decoder as! (Data) throws -> U) as! T }) ?? requestUrlDecoderReturnValue as! T
    }
}
