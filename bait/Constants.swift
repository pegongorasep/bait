//
//  Constants.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation

struct Constants {
    static var isLoggedIn: Bool {
        get { return UserDefaults.standard.bool(forKey: "isLoggedIn") }
        set { UserDefaults.standard.set(newValue, forKey: "isLoggedIn") }
    }
        
    static var user: User? {
        get { return loadObject(key: "user") }
        set { return saveObject(newValue, key: "user") }
    }
    
    static var token: String? {
        get { return loadObject(key: "token") }
        set { return saveObject(newValue, key: "token") }
    }
    
    private static func saveObject<T: Codable>(_ object: T, key: String) {
        if let encoded = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    private static func loadObject<T: Codable>(key: String) -> T? {
        if let savedObject = UserDefaults.standard.object(forKey: key) as? Data {
            return try? JSONDecoder().decode(T.self, from: savedObject)
        } else {
            return nil
        }
    }
}
