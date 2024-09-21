//
//  Publisher+asyncMap.swift
//  CoatOfArms
//
//  Created on 30/8/24.
//

import Combine

/// Enables Combine to map in asynchronous context
extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        self.flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}
