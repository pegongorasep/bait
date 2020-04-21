//
//  TokenAdapter.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation
import Alamofire

public class TokenAdapter: RequestAdapter {
    private let accessToken: String
    
    public func getCurrentToken() -> String {
        return accessToken
    }
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(self.accessToken, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}
