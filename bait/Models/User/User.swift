//
//  User.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let name: String
    let lastname: String
    
    let tenant: Tenant?
    
    var token: String?
}

struct Tenant: Codable {
    let house: House?
}

struct House: Codable {
    let condominium_id: Int?
}
