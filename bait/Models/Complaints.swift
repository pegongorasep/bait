//
//  Complaints.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation

struct Complaints: Codable {
    let complaints: [ComplaintItem]
}

struct ComplaintItem: Codable {
    let id: Int
    let title: String
    let description: String
    let user_id: Int
    var complaint_state_id: Int
    let complaint_type_id: String?
    let condominium_id: String
    let created_at: String
    let updated_at: String
    let complaint_state: ComplaintState
    let user: User
}

struct ComplaintState: Codable {
    let id: Int
    let name: String
    let icon: String
    let user_id: Int
    let created_at: String
    let updated_at: String
}

