//
//  GameStatus.swift
//  CoatOfArms
//
//  Created on 8/9/24.
//

enum GameStatus<
    QuestionViewModel: QuestionViewModelProtocol,
    RemainingLives: RemainingLivesViewModelProtocol
> {
    case idle
    case playing(question: QuestionViewModel, remainingLives: RemainingLives)
    case gameOver(score: Int)
}

extension GameStatus {
    var isIdle: Bool {
        return switch self {
        case .idle:
            true
        default:
            false
        }
    }
    
    var gameOverScore: Int? {
        return switch self {
        case .gameOver(let score):
            score
        default:
            nil
        }
    }
    
    var playing: (question: QuestionViewModel, lives: RemainingLives)? {
        return switch self {
        case .playing(let question, let lives):
            (question, lives)
        default:
            nil
        }
    }
}
