//
//  GeoLocation.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/23/21.
//

import Foundation

struct GeoLocation {
    let latitude, longitude: String
}

extension GeoLocation: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
    }
}
