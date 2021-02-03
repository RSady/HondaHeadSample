//
//  TorqueSpec.swift
//  HondaHead
//
//  Created by Ryan Sady on 12/21/20.
//

import Foundation
import UIKit

struct TorqueSpec: Codable {
    let id: Int
    let series: String
    let section: String
    let item: String
    let torque: String
    let notes: String
    let imageRef: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case series = "series"
        case section = "section"
        case item = "item"
        case torque = "torque"
        case notes = "notes"
        case imageRef = "image"
        
    }
}

extension TorqueSpec {
    var searchText: String {
        return "\(section) \(item) \(torque) \(notes)"
    }
    
    var image: UIImage? {
        return UIImage(named: "imageRef")
    }
}


enum TorqueSpecClasses: String, CaseIterable {
    case BSeries = "B-Series"
    case DSeries = "D-Series"
    case KSeries = "K-Series"
}
