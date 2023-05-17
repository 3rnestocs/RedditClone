//
//  UserDefaultsManager.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    enum DataKey: String {
        case secretClient
        case sessionToken
        case refreshToken
    }
    
    private init() {}
    
    func save<T: Codable>(_ value: T, type: DataKey) {
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(value), forKey: type.rawValue
        )
    }
    
    func saveValue(_ value: Any?, type: DataKey) {
        UserDefaults.standard.set(value, forKey: type.rawValue)
    }
    
    func get<T: Codable>(_ object: T.Type, type: DataKey) -> T? {
        var userData: T?
        if let data = UserDefaults.standard.value(forKey: type.rawValue) as? Data {
            userData = try? PropertyListDecoder().decode(T.self, from: data)
            return userData
        } else {
            return userData
        }
    }
    
    func getValue(type: DataKey) -> Any? {
        UserDefaults.standard.value(forKey: type.rawValue)
    }
    
    func remove(type: DataKey) {
        UserDefaults.standard.removeObject(forKey: type.rawValue)
    }
}

