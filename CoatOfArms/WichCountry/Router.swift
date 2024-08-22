//
//  Router.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import Combine
import ReactiveStorage
import SwiftUI

protocol RouterProtocol: ObservableObject {
    var code: CountryCode { get }
    func next() async
}

final class Router: RouterProtocol {
    
    // MARK: Injected

    private let countryCodeProvider: CountryCodeProviderProtocol
    private let storage: ReactiveStorageProtocol
    
    // MARK: RouterProtocol
    
    @Published var code: CountryCode

    // MARK: Lifecycle
    
    init(
        countryCodeProvider: CountryCodeProviderProtocol,
        storage: ReactiveStorageProtocol
    ) {
        self.countryCodeProvider = countryCodeProvider
        self.storage = storage
        
        let code = countryCodeProvider.generateCode(excluding: [])
        self.code = code
    }
    
    // MARK: RouterProtocol
    
    func next() async {
        let alreadyAnswered = await self.storage.getAllElements(of: UserChoice.self).map(\.id)
        await MainActor.run {
            self.code = self.countryCodeProvider.generateCode(excluding: alreadyAnswered)
        }
    }
}
