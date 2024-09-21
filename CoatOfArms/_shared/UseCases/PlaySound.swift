//
//  PlaySound.swift
//  CoatOfArms
//
//  Created on 20/9/24.
//

import AudioToolbox

enum Sound: SystemSoundID {
    case rightAnswer = 1057
    case wrongAnswer = 1006
}

protocol PlaySoundProtocol {
    func play(sound: Sound) async
}

final class PlaySound: PlaySoundProtocol {
    func play(sound: Sound) async {
        await withCheckedContinuation { continuation in
            AudioServicesPlaySystemSoundWithCompletion(sound.rawValue) {
                continuation.resume()
            }
        }
    }
}

// MARK: - PlaySoundProtocolMock -

final class PlaySoundProtocolMock: PlaySoundProtocol {
    
    
   // MARK: - play

    var playSoundCallsCount = 0
    var playSoundCalled: Bool {
        playSoundCallsCount > 0
    }
    var playSoundReceivedSound: Sound?
    var playSoundReceivedInvocations: [Sound] = []
    var playSoundClosure: ((Sound) -> Void)?

    func play(sound: Sound) {
        playSoundCallsCount += 1
        playSoundReceivedSound = sound
        playSoundReceivedInvocations.append(sound)
        playSoundClosure?(sound)
    }
}
