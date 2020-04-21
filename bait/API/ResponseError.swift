//
//  ResponseError.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation

struct ResponseError: Codable {
    let message: String
    let errors: [String]
    let exception: String
}
