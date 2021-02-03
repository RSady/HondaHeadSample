//
//  AppInfo.swift
//  HondaHead
//
//  Created by Ryan Sady on 12/2/20.
//

import Foundation

struct AppInfo {
    
    static var appName : String {
        return readFromInfoPlist(withKey: "CFBundleName") ?? ""
    }
    
    static var version : String {
        return readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? ""
    }
    
    static var build : String {
        return readFromInfoPlist(withKey: "CFBundleVersion") ?? ""
    }
    
    static var minimumOSVersion : String {
        return readFromInfoPlist(withKey: "MinimumOSVersion") ?? ""
    }
    
    static var copyrightNotice : String {
        return readFromInfoPlist(withKey: "NSHumanReadableCopyright") ?? ""
    }
    
    static var bundleIdentifier : String {
        return readFromInfoPlist(withKey: "CFBundleIdentifier") ?? ""
    }
    
    static var developer : String { return "my awesome name" }
    
    // lets hold a reference to the Info.plist of the app as Dictionary
    private static let infoPlistDictionary = Bundle.main.infoDictionary
    
    /// Retrieves and returns associated values (of Type String) from info.Plist of the app.
    private static func readFromInfoPlist(withKey key: String) -> String? {
        return infoPlistDictionary?[key] as? String
    }
}
