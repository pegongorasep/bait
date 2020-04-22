//
//  Constants.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation
import UIKit

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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
