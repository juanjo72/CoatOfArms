//
//  RemoteResource+MakeCountryResource.swift
//  CoatOfArms
//
//  Created by Juanjo García Villaescusa on 11/8/24.
//

import Foundation
import Network

enum DecodeError: Error {
    case empty
}

extension RemoteResource where T == Country {
    static func make(code: String) -> Self {
        Network.RemoteResource<Country>(
            url: URL(string: "https://restcountries.com/v3.1/alpha/\(code)")!,
            decoder: { data in
                guard let country = try JSONDecoder().decode(
                    [Country].self,
                    from: data
                ).first else {
                    throw DecodeError.empty
                }
                return country
            }
        )
    }
}
