//
//  ChoiceButtonViewModelTests.swift
//  CoatOfArms
//
//  Created on 23/9/24.
//

@testable import CoatOfArms
import Combine
import Testing

@Suite("ChoiceButtonVewModel", .tags(.logicLayer))
struct ChoiceButtonViewModelTests {
   
    // MARK: SUT

    private func makeSUT(
        countryCode: CountryCode = "ES",
        gameSettings: GameSettings = .default,
        getCountryName: @escaping (CountryCode) -> String = { _ in "Spain" },
        playSound: @escaping (SoundEffect) async -> Void = { _ in },
        repository: ChoiceButtonRepositoryProtocolMock = .init(),
        router: GameRouterProtocolMock = .init()
    ) -> some ChoiceButtonViewModelProtocol {
        ChoiceButtonViewModel(
            countryCode: countryCode,
            gameSettings: gameSettings,
            getCountryName: getCountryName,
            outputScheduler: ImmediateScheduler.shared,
            playSound: playSound, repository: repository,
            router: router
        )
    }
    
    // MARK: label
    
    @Test("Button label")
    func testThat_WhenViewWillAppear_ThenLabelIsCreatedWithUseCase() async throws {
        // Given
        let getCountryName: (CountryCode) -> String = { _ in "Spain" }
        let repository = ChoiceButtonRepositoryProtocolMock()
        repository.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        let sut = makeSUT(
            getCountryName: getCountryName,
            repository: repository
        )
        
        // When
        await sut.viewWillAppear()
        
        // Then
        #expect(sut.label == "Spain")
    }
    
    // MARK: tint
    
    @Test(
        "Button color",
        arguments: [
            nil,
            UserChoice.make(countryCode: "ES", pickedCountryCode: "IT"),
            UserChoice.make(countryCode: "IT", pickedCountryCode: "IT"),
        ]
    )
    func testThat_WhenCreated_ThenTintIsApplied(userChoice: UserChoice?) async throws {
        // Given
        let repository = ChoiceButtonRepositoryProtocolMock()
        repository.userChoiceObservable = Just(userChoice).eraseToAnyPublisher()
        
        // When
        let sut = self.makeSUT(
            repository: repository
        )
        
        // Then
        #expect(sut.tint == userChoice.resultColor)
    }
    
    // MARK: userDidTap
    
    @Test("Setting answer")
    func testThat_WhenUserDidTap_ThenAnswerIsSet() async throws {
        // Given
        let repository = ChoiceButtonRepositoryProtocolMock()
        repository.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        repository.markAsChoiceReturnValue = UserChoice.make()
        let sut = makeSUT(
            repository: repository
        )
        
        // When
        await sut.userDidTap()
        
        // Then
        #expect(repository.markAsChoiceCallsCount == 1)
    }
    
    @Test("Playing sound: correct")
    func testThat_WhenUserDidTap_ThenCorrectFXSoundIsPlayed() async throws {
        // Given
        let returnChoice = UserChoice.make(
            countryCode: "ES",
            pickedCountryCode: "ES"
        )
        var soundToPlay: SoundEffect?
        let playSound: (SoundEffect) async -> Void = { soundToPlay = $0 }
        let repository = ChoiceButtonRepositoryProtocolMock()
        repository.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        repository.markAsChoiceReturnValue = returnChoice
        let sut = makeSUT(
            playSound: playSound,
            repository: repository
        )
        
        // When
        await sut.userDidTap()
        
        // Then
        #expect(soundToPlay == .rightAnswer)
    }
    
    @Test("Playing sound: incorrect")
    func testThat_WhenUserDidTap_ThenIncorrectFXSoundIsPlayed() async throws {
        // Given
        let returnChoice = UserChoice.make(
            countryCode: "ES",
            pickedCountryCode: "IT"
        )
        var soundToPlay: SoundEffect?
        let playSound: (SoundEffect) async -> Void = { soundToPlay = $0 }
        let repository = ChoiceButtonRepositoryProtocolMock()
        repository.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        repository.markAsChoiceReturnValue = returnChoice
        let sut = makeSUT(
            playSound: playSound,
            repository: repository
        )
        
        // When
        await sut.userDidTap()
        
        // Then
        #expect(soundToPlay == .wrongAnswer)
    }
    
    @Test("Go to next question")
    func testThat_WhenUserDidTap_ThenDelayIsApplied() async throws {
        // Given
        let gameSettings = GameSettings.make(resultTime: .seconds(0))
        let repository = ChoiceButtonRepositoryProtocolMock()
        repository.userChoiceObservable = Just(nil).eraseToAnyPublisher()
        repository.markAsChoiceReturnValue = .make()
        let router = GameRouterProtocolMock()
        
        let sut = makeSUT(
            gameSettings: gameSettings,
            repository: repository,
            router: router
        )
        
        // When
        await sut.userDidTap()
        
        // Then
        #expect(router.gotNextQuestionCallsCount == 1)
    }
}
