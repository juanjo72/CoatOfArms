//
//  EntryPoint.swift
//  CoatOfArms
//
//  Created on 18/9/24.
//

import Network
import ReactiveStorage
import SwiftUI

/// Main View factory
struct EntryPoint {
    func make() -> some View {
        let gameSettings: GameSettings = .default
        let store = ReactiveStorage.ReactiveInMemoryStorage()
        let network = NetworkAdapter(sender: Network.RequestSender.shared())
        let style: RootStyle = .default
        let gameViewModelFactory = GameViewModelFactory(
            gameSettings: gameSettings,
            network: network,
            store: store
        )
        let rootViewModel = RootViewModel(
            gameProvider: gameViewModelFactory.make
        )
        return RootView(
            viewModel: rootViewModel,
            style: style
        )
    }
}
