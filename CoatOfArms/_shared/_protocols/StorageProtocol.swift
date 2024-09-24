//
//  StorageProtocol.swift
//  CoatOfArms
//
//  Created on 9/9/24.
//

import Combine
import Mockable
import ReactiveStorage

public typealias EntityType = Identifiable & Equatable

@Mockable
protocol StorageProtocol {
    func getAllElementsObservable<Entity: EntityType>(of type: Entity.Type) -> AnyPublisher<[Entity], Never>
    func getSingleElementObservable<Entity: EntityType>(of type: Entity.Type, id: Entity.ID) -> AnyPublisher<Entity?, Never>
    func getAllElements<Entity: EntityType>(of type: Entity.Type) async -> [Entity]
    func add<Entity: EntityType>(_ element: Entity) async
}

/// Conforming third party's component to local protocol
extension ReactiveStorage.ReactiveInMemoryStorage: StorageProtocol {}
