//
//  MultipartModek.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 22/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation

public struct MultipartModel {
    let data: Data
        let name: String
        let key: String
        let mimeType: String
        
        init(data: Data, name: String, key: String, mimeType: String) {
            self.data = data
            self.name = name
            self.key = key
            self.mimeType = mimeType
        }
    }
