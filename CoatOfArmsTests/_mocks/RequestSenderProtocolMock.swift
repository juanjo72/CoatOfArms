//
//  RequestSenderProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 12/8/24.
//

struct MockError: Error {}

@testable import Network

public final class RequestSenderProtocolMock<U>: RequestSenderProtocol {
    
   // MARK: - request<T>

    public var requestResourceThrowableError: Error?
    public var requestResourceCallsCount = 0
    public var requestResourceCalled: Bool {
        requestResourceCallsCount > 0
    }
    public var requestResourceReceivedResource: RemoteResource<U>?
    public var requestResourceReceivedInvocations: [RemoteResource<U>] = []
    public var requestResourceReturnValue: U!
    public var requestResourceClosure: ((RemoteResource<U>) throws -> U)?

    public func request<T>(resource: RemoteResource<T>) throws -> T {
        if let error = requestResourceThrowableError {
            throw error
        }
        guard let resource = resource as? RemoteResource<U> else {
            throw MockError()
        }
        requestResourceCallsCount += 1
        requestResourceReceivedResource = resource
        requestResourceReceivedInvocations.append(resource)
        return try requestResourceClosure.map({ try $0(resource) as! T }) ?? requestResourceReturnValue as! T
    }
}
