//
//  RemainingLivesViewModelProtocolMock.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

@testable import CoatOfArms

final class RemainingLivesViewModelProtocolMock: RemainingLivesViewModelProtocol {
    
   // MARK: - numberOfLives

    var numberOfLives: Int {
        get { underlyingNumberOfLives }
        set(value) { underlyingNumberOfLives = value }
    }
    private var underlyingNumberOfLives: Int!
    
   // MARK: - totalLives

    var totalLives: Int {
        get { underlyingTotalLives }
        set(value) { underlyingTotalLives = value }
    }
    private var underlyingTotalLives: Int!
}
