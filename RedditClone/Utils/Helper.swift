//
//  Helper.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import Foundation

class Helper {
    static func isAuthenticated() -> Bool {
        guard let auth = UserDefaultsManager.shared.getValue(type: .secretClient) as? String else {
            return false
        }
        return !auth.isEmpty
    }
    
    static func hasToken() -> Bool {
        guard let accessToken = UserDefaultsManager.shared.getValue(type: .sessionToken) as? String else {
            return false
        }
        return !accessToken.isEmpty
    }
    
    static var secretClient: String {
        String(
            (UserDefaultsManager.shared.getValue(type: .secretClient) as? String)?.dropLast(2) ?? ""
        )
    }
    
    static var accessToken: String {
        UserDefaultsManager.shared.getValue(type: .sessionToken) as? String ?? ""
    }
    
    static var refreshToken: String {
        UserDefaultsManager.shared.getValue(type: .refreshToken) as? String ?? ""
    }
}
