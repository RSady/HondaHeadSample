//
//  Transmission.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/12/20.
//

import Foundation

struct Transmission: Codable {
    let id: Int
    let series: String
    let code: String
    let engine: String
    let chassis: String
    let model: String
    let lsd: String
    let type: String
    let gears: Int
    let ratios: GearRatio?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case series = "series"
        case code = "code"
        case engine = "engine"
        case chassis = "chassis"
        case model = "model"
        case lsd = "lsd"
        case type = "type"
        case gears = "gears"
        case ratios = "ratios"
    }
}

extension Transmission {
    
    /// The info list to be displayed in a tableView or any type of list.
    var infoList: [TransDetail] {
        get {
            return [ (TransDetail(order: 01, key: "Found In", value: model)),
                     (TransDetail(order: 02, key: "Chassis Code", value: chassis)),
                     (TransDetail(order: 03, key: "Engine", value: engine)),
                     (TransDetail(order: 04, key: "Type", value: type)),
                     (TransDetail(order: 05, key: "LSD", value: lsd))
            ]
        }
        
        set { }
    }
    
    /// The gear ratios to be displayed in a tableView or any type of list.
    var gearRatioList: [TransDetail] {
        get {
            return [
                (TransDetail(order: 01, key: "1st Gear", value: (ratios?.first ?? "--") as String)),
                (TransDetail(order: 02, key: "2nd Gear", value: (ratios?.second ?? "--") as String)),
                (TransDetail(order: 03, key: "3rd Gear", value: (ratios?.third ?? "--") as String)),
                (TransDetail(order: 04, key: "4th Gear", value: (ratios?.fourth ?? "--") as String)),
                (TransDetail(order: 05, key: "5th Gear", value: (ratios?.fifth ?? "--") as String)),
                (TransDetail(order: 06, key: "6th Gear", value: (ratios?.sixth ?? "--") as String)),
                (TransDetail(order: 07, key: "Reverse", value: (ratios?.reverse ?? "--") as String)),
                (TransDetail(order: 08, key: "Final Drive", value: (ratios?.finalDrive ?? "--") as String))
            ]
        }
        
        set { }
    }
}

typealias TransDetail = (order: Int, key: String, value: String)

struct GearRatio: Codable {
    let first: String
    let second: String
    let third: String
    let fourth: String
    let fifth: String
    let sixth: String?
    let reverse: String
    let finalDrive: String
    
    enum CodingKeys: String, CodingKey {
        case first = "1st"
        case second = "2nd"
        case third = "3rd"
        case fourth = "4th"
        case fifth = "5th"
        case sixth = "6th"
        case reverse = "reverse"
        case finalDrive = "final_drive"
    }
}

enum TransmissionClass: String, CaseIterable {
    case BSeries = "B-Series"
    case DSeries = "D-Series"
    case FSeries = "F-Series"
    case HSeries = "H-Series"
    case KSeries = "K-Series"
}
