//
//  CoatOfArmsApp.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 11/8/24.
//

import ReactiveStorage
import SwiftUI

@main
struct CoatOfArmsApp: App {
    var body: some Scene {
        let storage = ReactiveInMemoryStorage()
        let router = GameRouter(
            gameSettings: .default,
            randomCountryCodeProvider: RandomCountryCodeProvider(),
            storage: storage
        )
        WindowGroup {
            GameView(
                storage: storage,
                style: .default,
                router: router
            )
        }
    }
}
