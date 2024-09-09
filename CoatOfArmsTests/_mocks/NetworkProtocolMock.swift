//
// NetworkProtocolMock.swift
// CoatOfArmsTests
//
// Created on 9/9/242
//

@testable import CoatOfArms
import Foundation

final class NetworkProtocolMock<U>: NetworkProtocol {
    
   // MARK: - request<Resource: Decodable>

    var requestUrlThrowableError: Error?
    var requestUrlCallsCount = 0
    var requestUrlCalled: Bool {
        requestUrlCallsCount > 0
    }
    var requestUrlReceivedUrl: URL?
    var requestUrlReceivedInvocations: [URL] = []
    var requestUrlReturnValue: U!
    var requestUrlClosure: ((URL) throws -> U)?

    func request<Resource: Decodable>(url: URL) throws -> Resource {
        if let error = requestUrlThrowableError {
            throw error
        }
        requestUrlCallsCount += 1
        requestUrlReceivedUrl = url
        requestUrlReceivedInvocations.append(url)
        return try requestUrlClosure.map({ try $0(url) as! Resource }) ?? requestUrlReturnValue as! Resource
    }
}
