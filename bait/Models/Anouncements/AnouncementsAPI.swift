//
//  TicketsAPI.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//


import Foundation
import Alamofire

private enum AnouncementsAPI: APIConfiguration {
    case getAnouncements
    
    var method: HTTPMethod {
        switch self {
        case .getAnouncements:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAnouncements:
            return "bulletins?page=1"
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .getAnouncements:
            return URLEncoding.default
        }
    }
        
    var parameters: Parameters? {
        switch self {
        case .getAnouncements:
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
extension Anouncements {
        
    static func getAnouncements(completion: @escaping (Swift.Result<Anouncements, APIError>) -> Void) {
        
        let adapter = APIManager.shared.sessionManager.adapter as! TokenAdapter
        print(adapter.getCurrentToken())
        
        APIManager.shared.request(urlRequest: AnouncementsAPI.getAnouncements) { (result: Swift.Result<Anouncements, APIError>) in
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
