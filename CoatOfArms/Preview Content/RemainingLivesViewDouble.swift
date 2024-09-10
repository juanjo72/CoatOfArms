//
//  RemainingLivesViewDouble.swift
//  CoatOfArms
//
//  Created on 10/9/24.
//

import Foundation

final class RemainingLivesViewModel_Double: RemainingLivesViewModelProtocol {
    let numberOfLives: Int
    let totalLives: Int
    
    init(
        numberOfLives: Int,
        totalLives: Int
    ) {
        self.numberOfLives = numberOfLives
        self.totalLives = totalLives
    }
}
