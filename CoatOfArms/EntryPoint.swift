//
//  EntryPoint.swift
//  CoatOfArms
//
//  Created on 18/9/24.
//

import Network
import ReactiveStorage
import SwiftUI

struct EntryPoint {
    private let gameSettings: GameSettings = {
        .default
    }()
    
    private let store: some StorageProtocol = {
        ReactiveStorage.ReactiveInMemoryStorage()
    }()
    
    private let network: some NetworkProtocol = {
        let requestSender = Network.RequestSender.shared()
        return NetworkAdapter(sender: requestSender)
    }()
    
    private let style: RootStyle = {
        .default
    }()
    
    func make() -> some View {
        let gameViewModelFactory = GameViewModelFactory(
            gameSettings: self.gameSettings,
            network: self.network,
            storage: self.store
        )
        let rootViewModel = RootViewModel(
            gameProvider: gameViewModelFactory.make
        )
        return RootView(
            viewModel: rootViewModel,
            style: self.style
        )
    }
}
