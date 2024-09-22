//
//  PlaySoundProtocolMock.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

@testable import CoatOfArms

final class PlaySoundProtocolMock: PlaySoundProtocol {
    
    
   // MARK: - play

    var playSoundCallsCount = 0
    var playSoundCalled: Bool {
        playSoundCallsCount > 0
    }
    var playSoundReceivedSound: SoundEffect?
    var playSoundReceivedInvocations: [SoundEffect] = []
    var playSoundClosure: ((SoundEffect) -> Void)?

    func play(sound: SoundEffect) {
        playSoundCallsCount += 1
        playSoundReceivedSound = sound
        playSoundReceivedInvocations.append(sound)
        playSoundClosure?(sound)
    }
}
