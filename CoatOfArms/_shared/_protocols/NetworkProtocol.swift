//
//  NetworkProtocol.swift
//  CoatOfArms
//
//  Created on 9/9/24.
//

import Foundation
import Network

protocol NetworkProtocol {
    func request<T>(url: URL, decoder: @escaping (Data) throws -> T) async throws -> T
}

/// Adapter converting third party's RequestSenderProtocol to local NetworkProtocol
struct NetworkAdapter: NetworkProtocol {
    private let sender: any Network.RequestSenderProtocol
    
    init(
        sender: any Network.RequestSenderProtocol
    ) {
        self.sender = sender
    }
    
    func request<T>(url: URL, decoder: @escaping (Data) throws -> T) async throws -> T {
        let resource = Network.RemoteResource(url: url, decoder: decoder)
        return try await self.sender.request(resource: resource)
    }
}
