//
// NetworkProtocol.swift
// CoatOfArms
//
// Created on 9/9/24
    
import Foundation
import Network

protocol NetworkProtocol {
    func request<Resource: Decodable>(url: URL) async throws -> Resource
}

struct NetworkAdapter: NetworkProtocol {
    private let sender: any Network.RequestSenderProtocol
    
    init(
        sender: any Network.RequestSenderProtocol
    ) {
        self.sender = sender
    }
    
    func request<Resource: Decodable>(url: URL) async throws -> Resource {
        let resource = Network.RemoteResource(url: url) { data in
            try JSONDecoder().decode(Resource.self, from: data)
        }
        return try await self.sender.request(resource: resource)
    }
}
