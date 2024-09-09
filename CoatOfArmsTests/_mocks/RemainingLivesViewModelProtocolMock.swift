//
// RemainingLivesViewModelProtocolMock.swift
// CoatOfArmsTests
//
// Created on 8/9/24
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
