//
//  Country+Decoder.swift
//  CoatOfArms
//
//  Created on 11/8/24.
//

import Foundation

/// Country's implementation for Decodable protocol
extension ServerCountry: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "cca2"
        case coatOfArms
    }
    
    enum CoatOfArms: String, CodingKey {
        case png
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let coatOfArms = try container.nestedContainer(keyedBy: CoatOfArms.self, forKey: .coatOfArms)
        let urlString = try coatOfArms.decode(String.self, forKey: .png)
        self.coatOfArmsURL = URL(string: urlString)!
    }
}
