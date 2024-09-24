//
//  ReactiveStorageProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 12/8/24.
//

@testable import CoatOfArms
import Combine

final class StorageProtocolMock<
    E: Identifiable & Equatable
>: StorageProtocol {
    
   // MARK: - getAllElementsObservable<Entity: Identifiable>

    var getAllElementsObservableOfCallsCount = 0
    var getAllElementsObservableOfCalled: Bool {
        getAllElementsObservableOfCallsCount > 0
    }
    var getAllElementsObservableOfReceivedType: E.Type?
    var getAllElementsObservableOfReceivedInvocations: [E.Type] = []
    var getAllElementsObservableOfReturnValue: AnyPublisher<[E], Never>!
    var getAllElementsObservableOfClosure: ((E.Type) -> AnyPublisher<[E], Never>)?

    func getAllElementsObservable<Entity: Identifiable>(of type: Entity.Type) -> AnyPublisher<[Entity], Never> {
        getAllElementsObservableOfCallsCount += 1
        guard let type = type as? E.Type else {
            return Just([]).eraseToAnyPublisher()
        }
        getAllElementsObservableOfReceivedType = type
        getAllElementsObservableOfReceivedInvocations.append(type)
        return getAllElementsObservableOfClosure.map({ $0(type) as! AnyPublisher<[Entity], Never> }) ?? getAllElementsObservableOfReturnValue as! AnyPublisher<[Entity], Never>
    }
    
   // MARK: - getSingleElementObservable<Entity: Identifiable>

    var getSingleElementObservableOfIdCallsCount = 0
    var getSingleElementObservableOfIdCalled: Bool {
        getSingleElementObservableOfIdCallsCount > 0
    }
    var getSingleElementObservableOfIdReceivedArguments: (type: E.Type, id: E.ID)?
    var getSingleElementObservableOfIdReceivedInvocations: [(type: E.Type, id: E.ID)] = []
    var getSingleElementObservableOfIdReturnValue: AnyPublisher<E?, Never>!
    var getSingleElementObservableOfIdClosure: ((E.Type, E.ID) -> AnyPublisher<E?, Never>)?

    func getSingleElementObservable<Entity: Identifiable>(of type: Entity.Type, id: Entity.ID) -> AnyPublisher<Entity?, Never> {
        getSingleElementObservableOfIdCallsCount += 1
        guard let type = type as? E.Type, let id = id as? E.ID else {
            return Just(nil).eraseToAnyPublisher()
        }
        getSingleElementObservableOfIdReceivedArguments = (type: type, id: id)
        getSingleElementObservableOfIdReceivedInvocations.append((type: type, id: id))
        return getSingleElementObservableOfIdClosure.map({ $0(type, id) as! AnyPublisher<Entity?, Never> }) ?? getSingleElementObservableOfIdReturnValue as! AnyPublisher<Entity?, Never>
    }
    
   // MARK: - getAllElements<Entity: Identifiable>

    var getAllElementsOfCallsCount = 0
    var getAllElementsOfCalled: Bool {
        getAllElementsOfCallsCount > 0
    }
    var getAllElementsOfReceivedType: E.Type?
    var getAllElementsOfReceivedInvocations: [E.Type] = []
    var getAllElementsOfReturnValue: [E]!
    var getAllElementsOfClosure: ((E.Type) -> [E])?

    func getAllElements<Entity: Identifiable>(of type: Entity.Type) async -> [Entity] {
        getAllElementsOfCallsCount += 1
        guard let type = type as? E.Type else {
            return []
        }
        getAllElementsOfReceivedType = type
        getAllElementsOfReceivedInvocations.append(type)
        return getAllElementsOfClosure.map({ $0(type) as! [Entity] }) ?? getAllElementsOfReturnValue as! [Entity]
    }
    
   // MARK: - add<Entity: Identifiable>

    var addCallsCount = 0
    var addCalled: Bool {
        addCallsCount > 0
    }
    var addReceivedElement: E?
    var addReceivedInvocations: [E] = []
    var addClosure: ((E) -> Void)?

    func add<Entity: Identifiable>(_ element: Entity) async {
        addCallsCount += 1
        guard let element = element as? E else {
            return
        }
        addReceivedElement = element
        addReceivedInvocations.append(element)
        addClosure?(element)
    }
}
