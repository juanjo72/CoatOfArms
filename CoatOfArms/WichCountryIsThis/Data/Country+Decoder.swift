//
//  Country+Decoder.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 11/8/24.
//

import Foundation

extension Country: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "cca2"
        case coatOfArms
    }
    
    enum CoatOfArms: String, CodingKey {
        case png
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        let coatOfArms = try values.nestedContainer(keyedBy: CoatOfArms.self, forKey: .coatOfArms)
        let urlString = try coatOfArms.decode(String.self, forKey: .png)
        self.coatOfArmsURL = URL(string: urlString)!
    }
}
