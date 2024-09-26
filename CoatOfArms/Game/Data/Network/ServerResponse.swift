//
//  ServerResponse.swift
//  CoatOfArms
//
//  Created on 26/9/24.
//

/// Entity decoding server's response.
/// Empty list case is considered an error.
struct ServerResponse {
    let country: ServerCountry
}

extension ServerResponse: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let countries = try container.decode([ServerCountry].self)
        guard let country = countries.first else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Empty array")
        }
        self.country = country
    }
}
