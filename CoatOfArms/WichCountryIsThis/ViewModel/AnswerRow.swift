//
//  AnswerRow.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 14/8/24.
//

/// View Data representing each one of the choices
struct AnswerRow {
    let id: CountryCode
    let label: String
    let isAnsweredCorrectly: Bool?
    
    init(
        id: CountryCode,
        label: String,
        isAnsweredCorrectly: Bool?
    ) {
        self.id = id
        self.label = label
        self.isAnsweredCorrectly = isAnsweredCorrectly
    }
}
