//
//  WhichCountryViewModel.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 13/8/24.
//

import Foundation
import Combine

protocol WhichCountryViewModelProtocol: ObservableObject {
    associatedtype Answers: MultipleChoiceViewModelProtocol
    var imageURL: URL? { get }
    var answers: Answers? { get }
    func viewWillAppear() async
}

final class WhichCountryViewModel<
    Answers: MultipleChoiceViewModelProtocol
>: WhichCountryViewModelProtocol {
    
    // MARK: Injected
    
    private let answersProvider: () async -> Answers
    private let repository: WhichCountryRepostoryProtocol
    
    // MARK: WhichCountryViewModelProtocol
    
    @Published var imageURL: URL?
    @Published var answers: Answers?
    
    // MARK: Observables
    
    private var imageURLObservable: some Publisher<URL?, Never> {
        self.repository.countryObservable()
            .map(\.?.coatOfArmsURL)
    }
    
    // MARK: Lifecycle
    
    init(
        answersProvider: @escaping () async -> Answers,
        repository: WhichCountryRepostoryProtocol
    ) {
        self.answersProvider = answersProvider
        self.repository = repository
        
        self.imageURLObservable
            .assign(to: &self.$imageURL)
    }
    
    // MARK: WhichCountryViewModelProtocol
    
    func viewWillAppear() async {
        do {
            try await self.repository.fetchCountry()
        } catch {
            print(String(describing: error))
        }
        self.answers = await answersProvider()
    }
}
