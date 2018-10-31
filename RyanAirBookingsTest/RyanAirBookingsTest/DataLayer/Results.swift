//
//  Results.swift
//  RyanAirBooker
//
//  Created by Ben Smith on 30/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation

struct Results: Codable {
    var trips: [Trips]
}

struct Trips: Codable {
    var origin: String?
    var destination: String?
    var dates: [Dates]?
}

struct Dates: Codable {
    
    var dateOut: String?
    var flights: [Flights]?
}

struct Flights: Codable {
    var flightNumber: String?
    var regularFare: RegularFare?
}

struct RegularFare: Codable {
    var fares: [Fares]
}
struct Fares: Codable {
    var type: String?
    var amount: Double
    var publishedFare: Double
}
