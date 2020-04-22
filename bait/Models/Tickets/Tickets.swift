//
//  Tickets.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation

struct Tickets: Codable {
    let complaint: Complaint
    let complaint_comment: ComplaintComment
}

struct Complaint: Codable {
    let id: Int
    let title: String
    let description: String
    let user_id: Int
    var complaint_state_id: Int
    let complaint_type_id: Int?
    let condominium_id: Int
    let created_at: String
    let updated_at: String
}
struct ComplaintComment: Codable {
    let id: Int
    let comment: String
    let user_id: Int
    var complaint_id: Int
    let created_at: String
    let updated_at: String
    let image_url: String?
}
