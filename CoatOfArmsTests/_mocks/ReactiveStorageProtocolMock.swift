//
//  ReactiveStorageProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 12/8/24.
//

import Combine
@testable import ReactiveStorage

final class ReactiveStorageProtocolMock<E: Identifiable>: ReactiveStorageProtocol {
    
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
    
   // MARK: - getSingleElement<Entity: Identifiable>

    var getSingleElementOfIdCallsCount = 0
    var getSingleElementOfIdCalled: Bool {
        getSingleElementOfIdCallsCount > 0
    }
    var getSingleElementOfIdReceivedArguments: (type: E.Type, id: E.ID)?
    var getSingleElementOfIdReceivedInvocations: [(type: E.Type, id: E.ID)] = []
    var getSingleElementOfIdReturnValue: E?
    var getSingleElementOfIdClosure: ((E.Type, E.ID) -> E?)?

    func getSingleElement<Entity: Identifiable>(of type: Entity.Type, id: Entity.ID) async -> Entity? {
        getSingleElementOfIdCallsCount += 1
        guard let type = type as? E.Type, let id = id as? E.ID else {
            return nil
        }
        getSingleElementOfIdReceivedArguments = (type: type, id: id)
        getSingleElementOfIdReceivedInvocations.append((type: type, id: id))
        return getSingleElementOfIdClosure.map({ $0(type, id) as! Entity }) ?? getSingleElementOfIdReturnValue as! Entity
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
    
   // MARK: - add<Entity: Identifiable>

    var addElementsCallsCount = 0
    var addElementsCalled: Bool {
        addCallsCount > 0
    }
    var addReceivedElements: [E]?
    var addElementsReceivedInvocations: [[E]] = []
    var addElementsClosure: (([E]) -> Void)?

    func add<Entity: Identifiable>(_ elements: [Entity]) async {
        addCallsCount += 1
        guard let elements = elements as? [E] else {
            return
        }
        addReceivedElements = elements
        addElementsReceivedInvocations.append(elements)
        addElementsClosure?(elements)
    }
    
   // MARK: - removeSingleElement<Entity: Identifiable>

    var removeSingleElementOfIdCallsCount = 0
    var removeSingleElementOfIdCalled: Bool {
        removeSingleElementOfIdCallsCount > 0
    }
    var removeSingleElementOfIdReceivedArguments: (type: E.Type, id: E.ID)?
    var removeSingleElementOfIdReceivedInvocations: [(type: E.Type, id: E.ID)] = []
    var removeSingleElementOfIdClosure: ((E.Type, E.ID) -> Void)?

    func removeSingleElement<Entity: Identifiable>(of type: Entity.Type, id: Entity.ID) async {
        removeSingleElementOfIdCallsCount += 1
        guard let type = type as? E.Type, let id = id as? E.ID else {
            return
        }
        removeSingleElementOfIdReceivedArguments = (type: type, id: id)
        removeSingleElementOfIdReceivedInvocations.append((type: type, id: id))
        removeSingleElementOfIdClosure?(type, id)
    }
    
   // MARK: - removeAllElements<Entity: Identifiable>

    var removeAllElementsOfCallsCount = 0
    var removeAllElementsOfCalled: Bool {
        removeAllElementsOfCallsCount > 0
    }
    var removeAllElementsOfReceivedType: E.Type?
    var removeAllElementsOfReceivedInvocations: [E.Type] = []
    var removeAllElementsOfClosure: ((E.Type) -> Void)?

    func removeAllElements<Entity: Identifiable>(of type: Entity.Type) {
        removeAllElementsOfCallsCount += 1
        guard let type = type as? E.Type else {
            return
        }
        removeAllElementsOfReceivedType = type
        removeAllElementsOfReceivedInvocations.append(type)
        removeAllElementsOfClosure?(type)
    }
}
