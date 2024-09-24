//
//  PlaySound.swift
//  CoatOfArms
//
//  Created on 20/9/24.
//

import AudioToolbox

enum SoundEffect: SystemSoundID {
    case rightAnswer = 1057
    case wrongAnswer = 1006
}

final class PlaySound {
    func callAsFunction(sound: SoundEffect) async {
        await withCheckedContinuation { continuation in
            AudioServicesPlaySystemSoundWithCompletion(sound.rawValue) {
                continuation.resume()
            }
        }
    }
}
