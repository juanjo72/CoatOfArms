//
//  Untitled.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//


@testable import CoatOfArms
import Combine

final class RemainingLivesRepositoryProtocolMock: RemainingLivesRepositoryProtocol {
    
   // MARK: - wrongAnswers

    var wrongAnswers: AnyPublisher<[UserChoice], Never> {
        get { underlyingWrongAnswers }
        set(value) { underlyingWrongAnswers = value }
    }
    private var underlyingWrongAnswers: AnyPublisher<[UserChoice], Never>!
}
