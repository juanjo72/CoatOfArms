//
//  CoatOfArmsApp.swift
//  CoatOfArms
//
//  Created on 11/8/24.
//

import Network
import ReactiveStorage
import SwiftUI

@main
struct CoatOfArmsApp: App {
    var body: some Scene {
        WindowGroup {
            let settings = GameSettings.default
            let storage = ReactiveStorage.ReactiveInMemoryStorage()
            let requestSender = Network.RequestSender.shared()
            let gameViewModelFactory = GameViewModelFactory(
                gameSettings: settings,
                requestSender: requestSender,
                storage: storage
            )
            let rootViewModel = RootViewModel(
                gameProvider: {
                    gameViewModelFactory.make(stamp: .now)
                }
            )

            RootView(viewModel: rootViewModel)
        }
    }
}
