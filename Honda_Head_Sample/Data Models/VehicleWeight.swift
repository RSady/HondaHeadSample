//
//  VehicleWeight.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/20/20.
//

import Foundation

struct VehicleWeight: Codable {
    let id: Int
    let year: Int
    let make: String
    let model: String
    let trim: String
    let transmission: String
    let weight: Int
}

extension VehicleWeight {
    /// A searchText containing all of the properties used for searching in a SearchBar
    var searchText: String {
        return "\(year) \(model) \(trim) \(transmission) \(weight)"
    }
}
