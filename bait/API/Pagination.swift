//
//  Pagination.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 22/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation

struct PaginatedData<T> {
    let data: [T]
    let pagination: PaginationInfo

    init(data: [T], pagination: PaginationInfo) {
        self.data = data
        self.pagination = pagination
    }
}

struct PaginationInfo {
    var currentPage: Int
    var nextPage: Int
    var hasMoreItems = false

    init(currentPage: Int, nextPage: Int, hasMoreItems: Bool) {
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.hasMoreItems = hasMoreItems
    }
}
