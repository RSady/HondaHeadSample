//
//  DataManager.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/5/20.
//

import Foundation

class DataManager {
    
    public static let shared = DataManager()
    
    func loadJson<T: Decodable>(from filename: String, completion: @escaping (T) -> ()) {
        if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let jsonData = try decoder.decode(T.self, from: data)
                completion(jsonData)
            } catch {
                print("Error: ", error)
            }
        } else {
            print("No resource: ", filename)
        }
        
    }
    
    
}

struct DataClasses {
    static let engines = "engines"
    static let cels = "cels"
    static let ecus = "ecu"
    static let transmissions = "transmissions"
    static let paintCodes = "paint_codes"
    static let vehicleWeights = "weight"
    static let chassisCodes = "chassis_codes"
    static let celCodes = "cel_codes"
    static let bearings = "bearings"
}
