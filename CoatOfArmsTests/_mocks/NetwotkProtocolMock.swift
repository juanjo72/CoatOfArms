//
//  NetworkProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 9/9/24.
//

@testable import CoatOfArms
import Foundation

final class NetworkProtocolMock<U: Decodable>: NetworkProtocol {
    
   // MARK: - request<T: Decodable>

    var requestUrlThrowableError: Error?
    var requestUrlCallsCount = 0
    var requestUrlCalled: Bool {
        requestUrlCallsCount > 0
    }
    var requestUrlReceivedUrl: URL?
    var requestUrlReceivedInvocations: [URL] = []
    var requestUrlReturnValue: U!
    var requestUrlClosure: ((URL) throws -> U)?

    func request<T: Decodable>(url: URL) throws -> T {
        if let error = requestUrlThrowableError {
            throw error
        }
        requestUrlCallsCount += 1
        requestUrlReceivedUrl = url
        requestUrlReceivedInvocations.append(url)
        return try requestUrlClosure.map({ try $0(url) as! T }) ?? requestUrlReturnValue as! T
    }
}
