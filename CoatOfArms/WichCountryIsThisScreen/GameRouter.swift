//
//  Router.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import Combine
import Foundation
import ReactiveStorage
import SwiftUI

protocol GameRouterProtocol: ObservableObject {
    var code: CountryCode { get }
    func next() async
}

/// General game's router
final class GameRouter<
    OutputScheduler: Scheduler
>: GameRouterProtocol {
    
    // MARK: Injected

    private let countryCodeProvider: CountryCodeProviderProtocol
    private let output: OutputScheduler
    private let storage: ReactiveStorageProtocol
    
    // MARK: RouterProtocol
    
    @Published var code: CountryCode

    // MARK: Lifecycle
    
    init(
        countryCodeProvider: CountryCodeProviderProtocol,
        output: OutputScheduler = DispatchQueue.main,
        storage: ReactiveStorageProtocol
    ) {
        self.countryCodeProvider = countryCodeProvider
        self.output = output
        self.storage = storage
        
        let code = countryCodeProvider.generateCode(excluding: [])
        self.code = code
    }
    
    // MARK: RouterProtocol
    
    func next() async {
        let alreadyAnswered = await self.storage.getAllElements(of: UserChoice.self).map(\.id)
        self.output.schedule {
            self.code = self.countryCodeProvider.generateCode(excluding: alreadyAnswered)
        }
    }
}
