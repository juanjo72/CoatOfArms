//
//  ContentView.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 11/8/24.
//

import ReactiveStorage
import SwiftUI

struct GameView: View {
    @StateObject private var router: Router
    private let storage: ReactiveStorageProtocol
    
    var body: some View {
        WhichCountryFactory(
            router: self.router,
            storage: self.storage
        ).make(code: self.router.code)
            .padding()
            .id(self.router.code)
    }
    
    init() {
        let storage = ReactiveInMemoryStorage()
        self._router = StateObject(
            wrappedValue: Router(
                countryCodeProvider: CountryCodeProvider(),
                storage: storage
            )
        )
        self.storage = storage
    }
}
