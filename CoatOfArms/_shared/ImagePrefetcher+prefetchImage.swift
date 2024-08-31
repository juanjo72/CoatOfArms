//
//  File.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 31/8/24.
//

import Foundation
import Kingfisher
import Combine

extension Publisher where Output == URL, Failure == Never {
    func prefetch() -> Publishers.FlatMap<Future<Bool, Never>, Self> {
        self.flatMap { value in
            Future { promise in
                Task {
                    Kingfisher.ImagePrefetcher(urls: [value]) { _, _, completed  in
                        promise(.success(!completed.isEmpty))
                    }.start()
                }
            }
        }
    }
}
