//
//  User.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation
import Alamofire

private enum UserAPI: APIConfiguration {
    case login(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "login/"
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .login:
            return URLEncoding.default
        }
    }
        
    var parameters: Parameters? {
        switch self {
        case .login(let parameters):
            return parameters
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: APIManager.shared.host + path, method: method)
        urlRequest = try encoding.encode(urlRequest, with: parameters)
        print(urlRequest)
        
        return urlRequest
    }
}

// MARK: - API Calls
extension User {
        
    static func login(email: String, password: String, completion: @escaping (Swift.Result<Token, APIError>) -> Void) {
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        APIManager.shared.request(urlRequest: UserAPI.login(parameters: parameters)) { (result: Swift.Result<Token, APIError>) in
            switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    switch error {
                        case .badRequestData(let data):
                            do {
                                let decoder = JSONDecoder()
                                let errorMessage = try decoder.decode(ResponseError.self, from: data)
                                completion(.failure(.responseErrorMessage(message: errorMessage.errors[0])))
                            } catch let parsingError {
                                print(parsingError)
                            }
                        default:
                            completion(.failure(error))
                            break
                    }
            }
        }
    }
    
}
