//
//  ReactiveStorageProtocolMock.swift
//  CoatOfArmsTests
//
//  Created on 12/8/24.
//

@testable import CoatOfArms
import Combine

final class StorageProtocolMock: StorageProtocol {
    
   // MARK: - getAllElementsObservable<Entity: Identifiable>

    var getAllElementsObservableOfCallsCount = 0
    var getAllElementsObservableOfCalled: Bool {
        getAllElementsObservableOfCallsCount > 0
    }
    var getAllElementsObservableOfReceivedType: Any.Type?
    var getAllElementsObservableOfReceivedInvocations: [Any.Type] = []
    var getAllElementsObservableOfReturnValue: Any!
    var getAllElementsObservableOfClosure: ((Any) -> Any)?

    func getAllElementsObservable<Entity: Identifiable>(of type: Entity.Type) -> AnyPublisher<[Entity], Never> {
        getAllElementsObservableOfCallsCount += 1
        getAllElementsObservableOfReceivedType = type
        getAllElementsObservableOfReceivedInvocations.append(type)
        return getAllElementsObservableOfClosure.map({ $0(type) }) as? AnyPublisher<[Entity], Never> ?? getAllElementsObservableOfReturnValue as! AnyPublisher<[Entity], Never>
    }
    
   // MARK: - getSingleElementObservable<Entity: Identifiable>

    var getSingleElementObservableOfIdCallsCount = 0
    var getSingleElementObservableOfIdCalled: Bool {
        getSingleElementObservableOfIdCallsCount > 0
    }
    var getSingleElementObservableOfIdReceivedArguments: (type: Any.Type, id: Any)?
    var getSingleElementObservableOfIdReceivedInvocations: [(type: Any, id: Any)] = []
    var getSingleElementObservableOfIdReturnValue: Any!
    var getSingleElementObservableOfIdClosure: ((Any.Type, Any) -> Any)?

    func getSingleElementObservable<Entity: Identifiable>(of type: Entity.Type, id: Entity.ID) -> AnyPublisher<Entity?, Never> {
        getSingleElementObservableOfIdCallsCount += 1
        getSingleElementObservableOfIdReceivedArguments = (type: type, id: id)
        getSingleElementObservableOfIdReceivedInvocations.append((type: type, id: id))
        return getSingleElementObservableOfIdClosure.map({ $0(type, id) as! AnyPublisher<Entity?, Never> }) ?? getSingleElementObservableOfIdReturnValue as! AnyPublisher<Entity?, Never>
    }
    
   // MARK: - getAllElements<Entity: Identifiable>

    var getAllElementsOfCallsCount = 0
    var getAllElementsOfCalled: Bool {
        getAllElementsOfCallsCount > 0
    }
    var getAllElementsOfReceivedType: Any.Type?
    var getAllElementsOfReceivedInvocations: [Any.Type] = []
    var getAllElementsOfReturnValue: Any!
    var getAllElementsOfClosure: ((Any.Type) -> [Any])?

    func getAllElements<Entity: Identifiable>(of type: Entity.Type) async -> [Entity] {
        getAllElementsOfCallsCount += 1
        getAllElementsOfReceivedType = type
        getAllElementsOfReceivedInvocations.append(type)
        return getAllElementsOfClosure.map({ $0(type) as! [Entity] }) ?? getAllElementsOfReturnValue as! [Entity]
    }
    
   // MARK: - add<Entity: Identifiable>

    var addCallsCount = 0
    var addCalled: Bool {
        addCallsCount > 0
    }
    var addReceivedElement: Any?
    var addReceivedInvocations: [Any] = []
    var addClosure: ((Any) -> Void)?

    func add<Entity: Identifiable>(_ element: Entity) async {
        addCallsCount += 1
        addReceivedElement = element
        addReceivedInvocations.append(element)
        addClosure?(element)
    }
}
