//
//  Prefetchimage.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

import Foundation
import Kingfisher

struct PrefetchImage {
    func callAsFunction(_ url: URL) async throws {
        try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
