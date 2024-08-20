//
//  WhichCountryViewModel.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 13/8/24.
//

import Foundation
import Combine

protocol WhichCountryViewModelProtocol: ObservableObject {
    associatedtype MultipleChoice: MultipleChoiceViewModelProtocol
    var imageURL: URL? { get }
    var multipleChoice: MultipleChoice? { get }
    func viewWillAppear() async
}

final class WhichCountryViewModel<
    MultipleChoice: MultipleChoiceViewModelProtocol
>: WhichCountryViewModelProtocol {
    
    // MARK: Injected
    
    private let multipleChoiceProvider: () -> MultipleChoice
    private let repository: WhichCountryRepostoryProtocol
    
    // MARK: WhichCountryViewModelProtocol
    
    @Published var imageURL: URL?
    @Published var multipleChoice: MultipleChoice?
    
    // MARK: Observables
    
    private var imageURLObservable: some Publisher<URL?, Never> {
        self.repository.countryObservable()
            .map(\.?.coatOfArmsURL)
    }
    
    // MARK: Lifecycle
    
    init(
        multipleChoiceProvider: @escaping () -> MultipleChoice,
        repository: WhichCountryRepostoryProtocol
    ) {
        self.multipleChoiceProvider = multipleChoiceProvider
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
        self.multipleChoice = self.multipleChoiceProvider()
    }
}
