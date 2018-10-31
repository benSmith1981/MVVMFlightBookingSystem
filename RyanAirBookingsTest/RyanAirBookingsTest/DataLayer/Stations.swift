//
//  Stations.swift
//  RyanAirBookingsTest
//
//  Created by Ben Smith on 31/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
struct StationList: Decodable {
    var stations: [Stations]
}

struct Stations: Decodable {
    var code: String?
    var countryCode: String?
    var countryName: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case countryCode
        case countryName

    }
}
