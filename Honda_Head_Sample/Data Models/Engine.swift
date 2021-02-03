//
//  Engine.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/4/20.
//

import Foundation
import UIKit

struct Engine: Codable {
    let id: Int
    let code: String
    let application: String
    let compression: String?
    let power: String?
    let torque: String?
    let redline: String?
    let revLimit: String?
    let vtec: String?
    let vtecType: String?
    let intakeManifold: String?
    let series: EngineSeries
    let bore: String
    let stroke: String
    let displacement: Int
    let obd: String?
    let valvetrain: String?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case code = "code"
        case application = "application"
        case compression = "compression"
        case power = "power"
        case torque = "torque"
        case redline = "redline"
        case revLimit = "rev_limit"
        case vtec = "vtec"
        case vtecType = "vtec_type"
        case intakeManifold = "intake_manifold"
        case series = "series"
        case bore = "bore"
        case stroke = "stroke"
        case displacement = "displacement"
        case obd = "obd"
        case valvetrain = "valvetrain"
        case notes = "notes"
    }
}


extension Engine {
    
    /// The info list to be displayed in a tableView or any type of list.
    var infoList: [EngineDetail] {
        get {
            return [
                EngineDetail(order: 01, key: "Found In", value: application),
                EngineDetail(order: 02, key: "Displacement", value: "\(displacement) cc"),
                EngineDetail(order: 03, key: "Bore & Stroke", value: "\(bore) mm x \(stroke) mm"),
                EngineDetail(order: 04, key: "Valvetrain", value: valvetrain ?? "--"),
                EngineDetail(order: 05, key: "Compression Ratio", value: compression ?? "--"),
                EngineDetail(order: 06, key: "Power", value: power ?? "--"),
                EngineDetail(order: 07, key: "Torque", value: torque ?? "--"),
                EngineDetail(order: 08, key: "VTEC Engagement", value: vtec ?? "--"),
                EngineDetail(order: 09, key: "VTEC Type", value: vtecType ?? "--"),
                EngineDetail(order: 10, key: "Redline", value: redline ?? "--"),
                EngineDetail(order: 11, key: "Rev Limit", value: revLimit ?? "--"),
                EngineDetail(order: 12, key: "Intake Manifold", value: intakeManifold ?? "--"),
                EngineDetail(order: 13, key: "OBD", value: "\(obd ?? "--")"),
                EngineDetail(order: 14, key: "Notes", value: notes ?? "")
            ]
        }
        
        set { }
    }
    
}

typealias EngineDetail = (order: Int, key: String, value: String)

enum EngineSeries: String, Codable {
    case ASeries = "A"
    case BSeries = "B"
    case CSeries = "C"
    case DSeries = "D"
    case FSeries = "F"
    case GSeries = "G"
    case HSeries = "H"
    case JSeries = "J"
    case KSeries = "K"
    case LSeries = "L"
    case NSeries = "N"
    case RSeries = "R"
}

struct EngineSubSeries: Hashable {
    let image: UIImage?
    let series: String
    let title: String
    let subtitle: String
}

struct EngineType {
    let series: EngineSeries
    let displayName: String
    let desc: String
    let image: UIImage?
}
