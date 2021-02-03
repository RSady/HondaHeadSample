//
//  PaintCode.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/4/20.
//

import Foundation

struct PaintCode: Codable {
    let id: Int
    let name: String
    let code: String
    let startYear: String
    let endYear: String?
    let make: String
    let paintType: String?
    let hexColor: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case startYear = "start_year"
        case endYear = "end_year"
        case paintType = "paint_type"
        case make
        case hexColor = "hex_color"
    }
}

extension PaintCode {
    /// A searchText containing all of the properties used for searching in a SearchBar
    var searchText: String {
        return "\(name) \(code) \(startYear) \(endYear ?? "") \(paintType ?? "")"
    }
}
