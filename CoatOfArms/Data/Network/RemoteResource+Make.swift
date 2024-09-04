//
//  RemoteResource+MakeCountryResource.swift
//  CoatOfArms
//
//  Created on 11/8/24.
//

import Foundation
import Network

enum DecodeError: Error {
    case empty
}

/// Factory to provide Remote resource to obtain Country detail, given a country code
extension RemoteResource where T == ServerCountry {
    static func make(code: String) -> Self {
        Network.RemoteResource<ServerCountry>(
            url: URL(string: "https://restcountries.com/v3.1/alpha/\(code)")!,
            decoder: { data in
                guard let country = try JSONDecoder().decode(
                    [ServerCountry].self,
                    from: data
                ).first else {
                    throw DecodeError.empty
                }
                return country
            }
        )
    }
}
