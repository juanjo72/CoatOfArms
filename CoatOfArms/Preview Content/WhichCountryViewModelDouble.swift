//
//  WhichCountryViewDouble.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 20/8/24.
//

import Foundation

final class WhichCountryViewModelDouble_Interactive: WhichCountryViewModelProtocol {
    var imageURL: URL? = URL(string: "https://mainfacts.com/media/images/coats_of_arms/ar.png")
    var multipleChoice: MultipleChoiceViewModelDouble_Interative? = .init()
    
    func viewWillAppear() async {}
}

final class WhichCountryViewModelDouble_RightChoice: WhichCountryViewModelProtocol {
    var imageURL: URL? = URL(string: "https://mainfacts.com/media/images/coats_of_arms/ar.png")
    var multipleChoice: MultipleChoiceViewModelDouble_RightChoice? = .init()
    
    func viewWillAppear() async {}
}

final class WhichCountryViewModelDouble_WrongChoice: WhichCountryViewModelProtocol {
    var imageURL: URL? = URL(string: "https://mainfacts.com/media/images/coats_of_arms/ar.png")
    var multipleChoice: MultipleChoiceViewModelDouble_WrongChoice? = .init()
    
    func viewWillAppear() async {}
}
