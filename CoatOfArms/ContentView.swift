//
//  ContentView.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 11/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WhichCountryFactory().make()
            .padding()
    }
}

#Preview {
    ContentView()
}
