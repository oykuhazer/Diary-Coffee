//
//  SessionManager.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.12.2024.
//

import Foundation

class SessionManager {
    
    static let shared = SessionManager()
    
    private init() {}
    
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    var versionWithBuild: String {
        return "\(appVersion).\(buildNumber)"
    }
}
