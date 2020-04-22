//
//  Tickets.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation

struct Anouncements: Codable {
    let bulletins: [Bulletins]
}

struct Bulletins: Codable {
    let id: Int
    let message: String
    let manager_condominium_id: Int
    let created_at: String
    let updated_at: String
    let title: String
    let fileURLs: [String]
    let attachments_count: Int
}
