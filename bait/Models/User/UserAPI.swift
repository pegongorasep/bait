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
    case getUserData
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getUserData:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "login/"
        case .getUserData:
            return "me/"
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .login, .getUserData:
            return URLEncoding.default
        }
    }
        
    var parameters: Parameters? {
        switch self {
        case .login(let parameters):
            return parameters
        case .getUserData:
            return nil
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
        
    static func getUserData(completion: @escaping (Swift.Result<UserData, APIError>) -> Void) {
        
        APIManager.shared.request(urlRequest: UserAPI.getUserData) { (result: Swift.Result<UserData, APIError>) in
            //result.response?.allHeaderFieldss
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
    
    static func login(email: String, password: String, completion: @escaping (Swift.Result<User, APIError>) -> Void) {
        let parameters = [
            "user": [
                "email": email,
                "password": password,
            ]
        ]
        
        APIManager.shared.request(urlRequest: UserAPI.login(parameters: parameters)) { (result: Swift.Result<User, APIError>) in
            //result.response?.allHeaderFieldss
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
