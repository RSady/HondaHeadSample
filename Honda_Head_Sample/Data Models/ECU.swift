//
//  ECU.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/4/20.
//

import Foundation

struct ECU: Codable {
    let id: Int
    let code: String
    let obd: Int
    let vtec: Int
    let foundIn: String
    let vtecCrossover: Int?
    let revLimit: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case code = "code"
        case obd = "obd"
        case vtec = "vtec"
        case foundIn = "found_in"
        case vtecCrossover = "crossover"
        case revLimit = "rev_limit"
    }
}

extension ECU {
    var searchText: String {
        return "\(code) \(foundIn)"
    }
}
