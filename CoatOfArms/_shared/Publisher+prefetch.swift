//
//  Publisher+prefetch.swift
//  CoatOfArms
//
//  Created by Juanjo García on 31/8/24.
//

import Combine
import Foundation
import Kingfisher

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
